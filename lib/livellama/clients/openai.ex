defmodule LiveLlama.OpenAI do
  @opts NimbleOptions.new! [
    model: [
      type: :string,
      required: true,
      doc: "ID of the model to use."
    ],
    messages: [
      type: {:list, {:map, :string, :string}},
      required: true,
      doc: "A list of messages comprising the conversation so far."
    ],
    stream: [
      type: :boolean,
      default: true,
      doc: """
      If set, partial message deltas will be sent, like in ChatGPT.
      Tokens will be sent as data-only server-sent events as they become available,
      with the stream terminated by a `data: [DONE]` message.
      """
    ],
    temperature: [
      type: :float,
      doc: """
      What sampling temperature to use, between 0 and 2.
      Higher values like 0.8 will make the output more random,
      while lower values like 0.2 will make it more focused and deterministic.

      We generally recommend altering this or `top_p` but not both.
      """
    ],
    top_p: [
      type: :float,
      doc: """
      An alternative to sampling with temperature, called nucleus sampling,
      where the model considers the results of the tokens with top_p probability mass.
      So 0.1 means only the tokens comprising the top 10% probability mass are considered.

      We generally recommend altering this or `temperature` but not both.
      """
    ],
    api_key: [
      type: :string,
      required: true
    ]
  ]
  @doc "Supported options:\n#{NimbleOptions.docs(@opts)}"
  def chat_completions(opts) do
    opts = NimbleOptions.validate!(opts, @opts)
    request = build_request(opts)

    if opts[:stream] do
      stream_response!(request)
    else
      response!(request)
    end
  end

  defp parse_chunk(chunk) do
    chunk
    |> String.split("\n\n")
    |> Enum.map(fn
      "" -> nil
      "data: [DONE]" -> nil
      "data: " <> json -> Jason.decode!(json)
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp stream_request!(request, stream_to, ref) do
    Req.request!(request, finch_request: fn request, finch_request, finch_name, finch_options ->
      on_chunk = fn chunk, response ->
        send(stream_to, {ref, chunk})
        response
      end

      case Finch.stream(finch_request, finch_name, Req.Response.new(), on_chunk, finch_options) do
        {:ok, response} -> {request, response}
        {:error, exception} -> {request, exception}
      end
    end)

    send(stream_to, {ref, :done})
  end

  defp stream_response!(request) do
    {stream_to, ref} = {self(), make_ref()}
    task = Task.async(fn -> stream_request!(request, stream_to, ref) end)
    Req.Response.new(
      status: receive do
        {^ref, {:status, status}} -> status
      end,
      hedaers: receive do
        {^ref, {:headers, headers}} -> headers
      end,
      body: Stream.resource(
        fn -> {ref, task} end,
        fn {ref, task} ->
          receive do
            {^ref, {:data, chunk}} -> {parse_chunk(chunk), {ref, task}}
            {^ref, :done} -> {:halt, {ref, task}}
          end
        end,
        fn {_ref, task} -> Task.shutdown(task) end
      )
    )
  end

  defp response!(request) do
    Req.request!(request)
  end

  defp build_request(opts) do
    Req.new(
      url: "https://api.openai.com/v1/chat/completions",
      method: :post,
      json: %{
        model: opts[:model],
        messages: opts[:messages],
        stream: opts[:stream],
      },
      auth: {:bearer, opts[:api_key]}
    )
  end
end
