defmodule LiveLlama.OpenAI do
  @opts NimbleOptions.new! [
    model: [
      type: :string,
      required: true,
      doc: "ID of the model to use."
    ],
    messages: [
      type: {:list, :map},
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
  ]
  @doc "Supported options:\n#{NimbleOptions.docs(@opts)}"
  def chat_completion(opts) do
    NimbleOptions.validate!(opts, @opts)
  end
end
