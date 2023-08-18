defmodule LiveLlama.Clients.OpenAI do
  @opts NimbleOptions.new!(
          model: [
            type: :string,
            required: true,
            doc: "ID of the model to use."
          ],
          messages: [
            type: {:list, {:map, :atom, :any}},
            required: true,
            doc: "A list of messages comprising the conversation so far."
          ],
          stream?: [
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
        )
  @doc "Supported options:\n#{NimbleOptions.docs(@opts)}"
  def chat_completions(opts) do
    opts
    |> NimbleOptions.validate!(@opts)
    |> build_request()
    |> then(fn
      %Req.Request{options: %{json: %{stream: false}}} = req ->
        response(req)

      %Req.Request{options: %{json: %{stream: true}}} = req ->
        stream_response(req)
    end)
  end

  defp parse_chunk(chunk) do
    chunk
    |> String.split("\n\n")
    |> Enum.map(fn
      "" -> nil
      "data: [DONE]" -> nil
      "data: " <> data -> data
      data -> data
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp stream_request(request, stream_to, ref) do
    Req.request(request,
      finch_request: fn request, finch_request, finch_name, finch_options ->
        on_chunk = fn chunk, response ->
          send(stream_to, {ref, chunk})
          response
        end

        case Finch.stream(finch_request, finch_name, Req.Response.new(), on_chunk, finch_options) do
          {:ok, response} -> {request, response}
          {:error, exception} -> {request, exception}
        end
      end
    )
    |> case do
      {:ok, _response} -> send(stream_to, {ref, :done})
      {:error, exception} -> send(stream_to, {ref, {:exception, exception}})
    end
  end

  defp stream_response(request) do
    {stream_to, ref} = {self(), make_ref()}
    request_task = Task.async(fn -> stream_request(request, stream_to, ref) end)

    receive do
      {^ref, {:exception, exception}} ->
        {:error, exception}

      {^ref, {:status, status}} ->
        headers =
          receive do
            {^ref, {:headers, headers}} -> headers
          end

        body =
          Stream.resource(
            fn -> [] end,
            fn [] ->
              receive do
                {^ref, {:data, chunk}} -> {parse_chunk(chunk), []}
                {^ref, :done} -> {:halt, []}
              end
            end,
            fn [] -> Task.shutdown(request_task) end
          )

        {:ok, Req.Response.new(status: status, headers: headers, body: body)}
    end
  end

  defp response(request) do
    Req.request(request)
  end

  defp build_request(opts) do
    Req.new(
      url: "https://api.openai.com/v1/chat/completions",
      method: :post,
      json: %{
        model: opts[:model],
        messages: opts[:messages],
        stream: opts[:stream?]
      },
      auth: {:bearer, opts[:api_key]}
    )
  end
end
