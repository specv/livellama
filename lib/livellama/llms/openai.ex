defmodule LiveLlama.LLMs.OpenAI do
  require Logger
  alias LiveLlama.Chats.Message

  @unkown_error "Unknown error occurred. Please try again later."
  @internal_error_codes ["insufficient_quota", "invalid_api_key"]

  def chat(model, messages, api_key) do
    LiveLlama.Clients.OpenAI.chat_completions(
      model: model,
      messages: transform_messages(messages),
      api_key: api_key,
      stream?: true
    )
    |> case do
      {:ok, response} ->
        response
        |> Map.get(:body)
        |> Stream.map(&Jason.decode!/1)
        |> Stream.map(fn
          %{"choices" => [%{"delta" => %{"role" => "assistant"}}]} ->
            nil

          %{"choices" => [%{"delta" => %{"content" => content}}]} ->
            {:ok, content}

          %{"choices" => [%{"finish_reason" => "stop"}]} ->
            nil

          error ->
            {:error,
             if error["error"]["code"] in @internal_error_codes do
               Logger.error(error)
               @unkown_error
             else
               error["error"]["message"]
             end}
        end)
        |> Stream.reject(&is_nil/1)

      {:error, exception} ->
        Logger.error(exception)
        [{:error, @unkown_error}]
    end
  end

  def transform_messages(messages) do
    messages
    |> Enum.map(&%{role: &1.role, content: &1.content})
  end

  def user_message(chat_id, messages, message) do
    Message.create!(%{chat_id: chat_id, role: :user, content: message})

    messages ++
      [
        %Message{
          role: :user,
          content: message,
          error: ""
        },
        %{
          role: :assistant,
          content: "",
          error: ""
        }
      ]
  end

  def assistant_message(chat_id, messages, message, error) do
    Message.create!(%{chat_id: chat_id, role: :assistant, content: message, error: error})

    List.update_at(messages, -1, fn msg ->
      msg
      |> Map.put(:content, message)
      |> Map.put(:error, error)
    end)
  end
end
