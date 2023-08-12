defmodule LiveLlama.LLMs.OpenAI do
  def chat(model, messages, api_key) do
    LiveLlama.Clients.OpenAI.chat_completions!(
      model: model,
      messages: messages,
      api_key: api_key,
      stream?: true
    )
    |> Map.get(:body)
    |> Stream.map(fn
      %{"choices" => [%{"delta" => %{"role" => "assistant"}}]} -> nil
      %{"choices" => [%{"finish_reason" => "stop"}]} -> nil
      %{"choices" => [%{"delta" => delta}]} -> Map.get(delta, "content")
    end)
    |> Stream.reject(&is_nil(&1))
  end

  def user_message(messages, message) do
    messages ++
      [
        %{
          "role" => "user",
          "content" => message
        },
        %{
          "role" => "assistant",
          "content" => ""
        }
      ]
  end

  def assistant_message(messages, chunk) do
    List.update_at(
      messages,
      -1,
      fn m -> Map.update!(m, "content", &(&1 <> chunk)) end
    )
  end
end
