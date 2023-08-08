defmodule LiveLlama.LLMs.OpenAI do
  def chat(model, messages, api_key) do
    LiveLlama.Clients.OpenAI.chat_completions!(
      model: model,
      messages: messages,
      api_key: api_key,
      stream?: true
    )
    |> Map.get(:body)
    |> Stream.map(fn %{"choices" => [%{"delta" => delta}]} ->
      Map.get(delta, "content", "")
    end)
  end
end
