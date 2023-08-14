defmodule LiveLlamaWeb.ChatsLive.PromptContainerComponent do
  use LiveLlamaWeb, :live_component
  alias LiveLlama.LLMs.OpenAI

  def render(assigns) do
    ~H"""
    <%!-- Prompt Messages Container - Modify the height according to your need --%>
    <div class="flex h-[100vh] w-full flex-col">
      <%!-- Prompt Messages --%>
      <div class="messages flex-1 space-y-6 overflow-y-auto bg-slate-200 p-4 text-sm leading-6 text-slate-900 shadow-sm dark:bg-slate-900 dark:text-slate-300 sm:text-base sm:leading-7">
        <div
          :for={msg <- @messages}
          :if={msg["role"] != "system"}
          phx-mounted={JS.dispatch("scroll-to-bottom", to: ".messages")}
        >
          <.user_message :if={msg["role"] == "user"} message={msg["content"]} />
          <.assistant_message
            :if={msg["role"] == "assistant"}
            message={msg["content"]}
            status={@status}
          />
        </div>
      </div>
      <%!-- Prompt message input --%>
      <.input_message myself={@myself} status={@status} />
    </div>
    """
  end

  defp user_message(assigns) do
    ~H"""
    <div class="flex flex-row-reverse items-start">
      <div class="flex-shrink-0 ml-2 h-8 w-8">
        <img class="rounded-full" src="https://dummyimage.com/128x128/363536/ffffff&text=J" />
      </div>
      <div class="flex min-h-[85px] rounded-b-xl rounded-tl-xl bg-slate-50 p-4 dark:bg-slate-800 sm:min-h-0 sm:max-w-md md:max-w-2xl whitespace-pre-wrap break-words overflow-x-auto">
        <p><%= @message %></p>
      </div>
    </div>
    """
  end

  defp assistant_message(assigns) do
    ~H"""
    <div class="flex items-start">
      <div class="flex-shrink-0 mr-2 h-8 w-8 ">
        <img class="rounded-full" src="https://dummyimage.com/128x128/354ea1/ffffff&text=G" />
      </div>

      <div class="flex rounded-b-xl rounded-tr-xl bg-slate-50 p-4 dark:bg-slate-800 sm:max-w-md md:max-w-2xl">
        <.loading show={@status == :waiting and @message == ""} />
        <p><%= @message %></p>
      </div>
      <div class="ml-2 mt-1 flex flex-col-reverse gap-2 text-slate-500 sm:flex-row">
        <.icon_thumbs_up />
        <.icon_thumbs_down />
        <.icon_copy />
      </div>
    </div>
    """
  end

  defp input_message(assigns) do
    ~H"""
    <form
      class="border-t border-slate-300 dark:border-slate-700"
      phx-submit="submit"
      phx-target={@myself}
    >
      <label for="input-message" class="sr-only">Enter your prompt</label>
      <div class="relative">
        <.icon_voice />
        <textarea
          id="input-message"
          name="input-message"
          class="block w-full resize-none border-none bg-slate-200 p-4 pl-10 pr-20 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600 focus:invalid:ring-pink-600 dark:bg-slate-900 dark:text-slate-200 dark:placeholder-slate-400 dark:focus:ring-blue-600 sm:text-base"
          placeholder="Enter your prompt"
          rows="1"
          required
          autofocus
          phx-hook="EnterSubmit"
          oninvalid="setCustomValidity(' ')"
        />
        <button
          type="submit"
          class="absolute bottom-2 right-2.5 rounded-lg bg-blue-700 px-4 py-2 text-sm font-medium text-slate-200 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 sm:text-base disabled:opacity-50 disabled:pointer-events-none"
          disabled={@status != :finished}
        >
          Send <span class="sr-only">Send message</span>
        </button>
      </div>
    </form>
    """
  end

  defp loading(assigns) do
    ~H"""
    <div
      class={[@show or "hidden", "flex min-h-[28px] justify-center items-center"]}
      aria-hidden="true"
    >
      <div class="flex animate-pulse space-x-2">
        <div class="h-2 w-2 rounded-full bg-slate-600"></div>
        <div class="h-2 w-2 rounded-full bg-slate-600"></div>
        <div class="h-2 w-2 rounded-full bg-slate-600"></div>
      </div>
    </div>
    """
  end

  defp icon_copy(assigns) do
    ~H"""
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
        <path d="M8 8m0 2a2 2 0 0 1 2 -2h8a2 2 0 0 1 2 2v8a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2 -2z"></path>
        <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
      </svg>
    </button>
    """
  end

  defp icon_thumbs_up(assigns) do
    ~H"""
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
    """
  end

  defp icon_thumbs_down(assigns) do
    ~H"""
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
    """
  end

  defp icon_voice(assigns) do
    ~H"""
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
        <path d="M9 2m0 3a3 3 0 0 1 3 -3h0a3 3 0 0 1 3 3v5a3 3 0 0 1 -3 3h0a3 3 0 0 1 -3 -3z"></path>
        <path d="M5 10a7 7 0 0 0 14 0"></path>
        <path d="M8 21l8 0"></path>
        <path d="M12 17l0 4"></path>
      </svg>
      <span class="sr-only">Use voice input</span>
    </button>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       status: :finished,
       messages: []
     )}
  end

  def handle_event("submit", %{"input-message" => message}, socket) do
    socket = update(socket, :messages, &OpenAI.user_message(&1, message))

    myself = self()
    # Task.async
    spawn(fn ->
      OpenAI.chat(
        "gpt-3.5-turbo-0301",
        socket.assigns.messages,
        System.fetch_env!("OPENAI_API_KEY")
      )
      |> Stream.map(fn chunk ->
        :timer.sleep(50)
        send_update(myself, __MODULE__, id: socket.assigns.id, streaming: chunk)
        chunk
      end)
      |> Enum.join()
      |> then(&send_update(myself, __MODULE__, id: socket.assigns.id, finished: &1))
    end)

    {:noreply, assign(socket, status: :waiting)}
  end

  def update(%{streaming: chunk}, socket) do
    {:ok,
     socket
     |> assign(status: :streaming)
     |> Phoenix.LiveView.push_event("streaming-chunk-received", %{"chunk" => chunk})}
  end

  def update(%{finished: message}, socket) do
    {:ok,
     socket
     |> assign(status: :finished)
     |> update(:messages, &OpenAI.assistant_message(&1, message))}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
