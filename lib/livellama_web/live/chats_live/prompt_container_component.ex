defmodule LiveLlamaWeb.ChatsLive.PromptContainerComponent do
  use LiveLlamaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <!-- Prompt Messages Container - Modify the height according to your need -->
      <div class="flex h-[100vh] w-full flex-col">
        <!-- Prompt Messages -->
        <div class="flex-1 space-y-6 overflow-y-auto bg-slate-200 p-4 text-sm leading-6 text-slate-900 shadow-sm dark:bg-slate-900 dark:text-slate-300 sm:text-base sm:leading-7">
          <%= for msg <- @messages, msg["content"] != "" do %>
            <%= case msg["role"] do %>
              <% "user" -> %>
                <.user_message message={msg["content"]} />
              <% "assistant" -> %>
                <.assistant_message message={msg["content"]} />
              <% _ -> %>
            <% end %>
          <% end %>
        </div>
        <!-- Prompt message input -->
        <.chat_input myself={@myself} />
      </div>
    </div>
    """
  end

  def user_message(assigns) do
    ~H"""
    <div class="flex items-start">
      <img
        class="mr-2 h-8 w-8 rounded-full"
        src="https://dummyimage.com/128x128/363536/ffffff&text=J"
      />
      <div class="flex rounded-b-xl rounded-tr-xl bg-slate-50 p-4 dark:bg-slate-800 sm:max-w-md md:max-w-2xl">
        <p><%= @message %></p>
      </div>
    </div>
    """
  end

  def assistant_message(assigns) do
    ~H"""
    <div class="flex flex-row-reverse items-start">
      <img
        class="ml-2 h-8 w-8 rounded-full"
        src="https://dummyimage.com/128x128/354ea1/ffffff&text=G"
      />

      <div class="flex min-h-[85px] rounded-b-xl rounded-tl-xl bg-slate-50 p-4 dark:bg-slate-800 sm:min-h-0 sm:max-w-md md:max-w-2xl">
        <p><%= @message %></p>
      </div>
      <div class="mr-2 mt-1 flex flex-col-reverse gap-2 text-slate-500 sm:flex-row">
        <button class="hover:text-blue-600" type="button">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M8 8m0 2a2 2 0 0 1 2 -2h8a2 2 0 0 1 2 2v8a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2 -2z">
            </path>
            <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
          </svg>
        </button>
        <button class="hover:text-blue-600" type="button">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M7 13v-8a1 1 0 0 0 -1 -1h-2a1 1 0 0 0 -1 1v7a1 1 0 0 0 1 1h3a4 4 0 0 1 4 4v1a2 2 0 0 0 4 0v-5h3a2 2 0 0 0 2 -2l-1 -5a2 3 0 0 0 -2 -2h-7a3 3 0 0 0 -3 3">
            </path>
          </svg>
        </button>
        <button class="hover:text-blue-600">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M7 11v8a1 1 0 0 1 -1 1h-2a1 1 0 0 1 -1 -1v-7a1 1 0 0 1 1 -1h3a4 4 0 0 0 4 -4v-1a2 2 0 0 1 4 0v5h3a2 2 0 0 1 2 2l-1 5a2 3 0 0 1 -2 2h-7a3 3 0 0 1 -3 -3">
            </path>
          </svg>
        </button>
      </div>
    </div>
    """
  end

  def chat_input(assigns) do
    ~H"""
    <form
      class="border-t border-slate-300 dark:border-slate-700"
      phx-submit="submit"
      phx-target={@myself}
    >
      <label for="chat-input" class="sr-only">Enter your prompt</label>
      <div class="relative">
        <button
          type="button"
          class="absolute inset-y-0 left-0 flex items-center pl-3 text-slate-500 hover:text-blue-600 dark:text-slate-400 dark:hover:text-blue-600"
        >
          <svg
            aria-hidden="true"
            class="h-5 w-5"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
            stroke-width="2"
            stroke="currentColor"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M9 2m0 3a3 3 0 0 1 3 -3h0a3 3 0 0 1 3 3v5a3 3 0 0 1 -3 3h0a3 3 0 0 1 -3 -3z">
            </path>
            <path d="M5 10a7 7 0 0 0 14 0"></path>
            <path d="M8 21l8 0"></path>
            <path d="M12 17l0 4"></path>
          </svg>
          <span class="sr-only">Use voice input</span>
        </button>
        <textarea
          id="chat-input"
          name="chat-input"
          class="block w-full resize-none border-none bg-slate-200 p-4 pl-10 pr-20 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600 dark:bg-slate-900 dark:text-slate-200 dark:placeholder-slate-400 dark:focus:ring-blue-600 sm:text-base"
          placeholder="Enter your prompt"
          rows="1"
          required
        />
        <button
          type="submit"
          class="absolute bottom-2 right-2.5 rounded-lg bg-blue-700 px-4 py-2 text-sm font-medium text-slate-200 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 sm:text-base"
        >
          Send <span class="sr-only">Send message</span>
        </button>
      </div>
    </form>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       messages: [
         %{
           "role" => "system",
           "content" =>
             "You are a chatbot that only answers questions about the programming language Elixir."
         },
         %{
           "role" => "user",
           "content" => "Hi. Please generate an sentence about elixir"
         },
         %{
           "role" => "assistant",
           "content" =>
             "Sure, here's a sentence: Elixir is a functional programming language built on top of the Erlang VM, designed for building scalable and maintainable applications."
         }
       ]
     )}
  end

  def handle_event("submit", %{"chat-input" => message}, socket) do
    socket =
      update(socket, :messages, fn messages ->
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
      end)

    myself = self()
    # Task.async
    spawn(fn ->
      LiveLlama.LLMs.OpenAI.chat(
        "gpt-3.5-turbo-0301",
        socket.assigns.messages,
        System.fetch_env!("OPENAI_API_KEY")
      )
      |> Stream.map(fn chunk ->
        :timer.sleep(50)
        send_update(myself, __MODULE__, id: socket.assigns.id, chunk: chunk)
      end)
      |> Stream.run()
    end)

    {:noreply, socket}
  end

  def update(%{chunk: chunk}, socket) do
    {:ok,
     update(socket, :messages, fn messages ->
       List.update_at(messages, -1, fn message ->
         %{message | "content" => message["content"] <> chunk}
       end)
     end)}
  end

  def update(assigns, socket) do
    {:ok, Enum.reduce(assigns, socket, fn {k, v}, acc -> assign(acc, k, v) end)}
  end
end
