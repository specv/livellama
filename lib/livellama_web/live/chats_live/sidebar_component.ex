defmodule LiveLlamaWeb.ChatsLive.SidebarComponent do
  use LiveLlamaWeb, :live_component
  alias LiveLlama.Chats.Chat

  @themes [
    %{name: "light", text: "Light", icon: "hero-sun"},
    %{name: "dark", text: "Dark", icon: "hero-moon"},
    %{name: "system", text: "System", icon: "hero-computer-desktop"}
  ]

  def render(assigns) do
    ~H"""
    <aside class="flex">
      <div class="flex h-[100svh] w-60 flex-col overflow-y-auto bg-slate-50 pt-8 dark:border-slate-700 dark:bg-slate-900 sm:h-[100vh] sm:w-64">
        <div class="flex items-center">
          <.logo count={length(@chats)} />
          <.theme_switcher
            myself={@myself}
            themes={@themes}
            selected_theme={@selected_theme}
            current_theme={@current_theme}
          />
        </div>
        <.new_chat myself={@myself} />
        <.chats
          myself={@myself}
          chats={@chats}
          current_chat_id={@current_chat && @current_chat.id}
          editing_chat_id={@editing_chat_id}
        />
        <.settings />
      </div>
    </aside>
    """
  end

  defp chats(assigns) do
    ~H"""
    <div class="h-1/2 space-y-4 overflow-y-auto border-b border-slate-300 px-2 py-4 dark:border-slate-700">
      <.chat
        :for={chat <- @chats}
        myself={@myself}
        chat={chat}
        current_chat_id={@current_chat_id}
        editing_chat_id={@editing_chat_id}
      />

      <.modal
        :for={chat <- @chats}
        id={"delete-chat-modal-#{chat.id}"}
        on_confirm={
          JS.push("delete_chat", value: %{chat_id: chat.id}, target: @myself)
          |> hide_modal("delete-chat-modal-#{chat.id}")
        }
      >
        Are you sure you want to delete "<%= chat.title %>"?
        <:cancel>Cancel</:cancel>
        <:confirm>Delete</:confirm>
      </.modal>
    </div>
    """
  end

  defp chat(assigns) do
    ~H"""
    <a
      phx-click="select_chat"
      phx-value-chat_id={@chat.id}
      phx-target={@myself}
      class={[
        "group relative flex w-full flex-col rounded-lg px-3 py-2 text-left focus:outline-none cursor-pointer",
        if(@chat.id == @current_chat_id,
          do: "bg-slate-200 dark:bg-slate-800",
          else: "hover:bg-slate-100 dark:hover:bg-slate-880"
        )
      ]}
    >
      <.chat_title
        :if={@chat.id != @editing_chat_id}
        myself={@myself}
        chat={@chat}
        mask_class={[
          "absolute inset-y-0 right-0 w-12 bg-gradient-to-l group-hover:from-65%",
          if(@chat.id == @current_chat_id,
            do:
              "from-slate-200 group-hover:from-slate-200 dark:from-slate-800 dark:group-hover:from-slate-800",
            else:
              "from-slate-50 group-hover:from-slate-100 dark:from-slate-900 dark:group-hover:from-slate-880"
          )
        ]}
      />
      <.chat_editor :if={@chat.id == @editing_chat_id} myself={@myself} chat={@chat} />
      <p class="text-xs text-slate-500 dark:text-slate-400">
        <%= @chat.inserted_at %>
      </p>
    </a>
    """
  end

  defp chat_title(assigns) do
    ~H"""
    <div class="w-full group">
      <div class="text-ellipsis max-h-5 overflow-hidden break-all relative">
        <h1 class="text-sm font-medium capitalize text-slate-700 dark:text-slate-200">
          <%= @chat.title %>
          <div class={@mask_class}></div>
        </h1>
      </div>
    </div>
    <div
      phx-click="edit_chat"
      phx-value-chat_id={@chat.id}
      phx-target={@myself}
      class="text-slate-500 dark:text-slate-400 opacity-0 group-hover:opacity-100 transition-opacity duration-200"
    >
      <div>
        <.icon
          name="hero-pencil-square"
          class="hover:text-blue-600 absolute top-1/2 transform -translate-y-1/2 right-6 h-4 w-4"
        />
      </div>
      <div phx-click={show_modal("delete-chat-modal-#{@chat.id}")}>
        <.icon
          name="hero-trash"
          class="hover:text-red-600 absolute top-1/2 transform -translate-y-1/2 right-1 h-4 w-4"
        />
      </div>
    </div>
    """
  end

  defp chat_editor(assigns) do
    ~H"""
    <form
      phx-submit="submit_edit_chat"
      phx-click-away="cancel_edit_chat"
      phx-target={@myself}
      class="flex w-full pr-8"
    >
      <input
        type="text"
        name="value"
        value={@chat.title}
        phx-mounted={JS.focus()}
        phx-target={@myself}
        onclick="event.stopPropagation()"
        onfocus="setSelectionRange(value.length, value.length); scrollLeft = scrollWidth"
        onkeyup="if(event.key === 'Enter') closest('form').dispatchEvent(new Event('submit', {bubbles: true, cancelable: true}))"
        class="text-sm font-medium capitalize text-slate-700 dark:text-slate-200 border-none bg-transparent w-full p-0 m-0"
      />
      <input name="chat_id" value={@chat.id} hidden />
      <div phx-click="cancel_edit_chat" phx-value-chat_id={@chat.id} phx-target={@myself}>
        <.icon
          name="hero-x-mark"
          class="text-gray-600 hover:text-black dark:text-gray-300 dark:hover:text-white hover:scale-110 absolute top-1/2 transform -translate-y-1/2 right-6 h-4 w-4"
        />
      </div>
      <div onclick="closest('form').dispatchEvent(new Event('submit', {bubbles: true, cancelable: true})); event.stopPropagation()">
        <.icon
          name="hero-check"
          class="text-gray-600 hover:text-black dark:text-gray-300 dark:hover:text-white hover:scale-110 absolute top-1/2 transform -translate-y-1/2 right-1 h-4 w-4"
        />
      </div>
    </form>
    """
  end

  defp logo(assigns) do
    ~H"""
    <div class="flex pl-4">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-7 w-7 text-blue-600"
        fill="currentColor"
        stroke-width="1"
        viewBox="0 0 24 24"
      >
        <path d="M20.553 3.105l-6 3C11.225 7.77 9.274 9.953 8.755 12.6c-.738 3.751 1.992 7.958 2.861 8.321A.985.985 0 0012 21c6.682 0 11-3.532 11-9 0-6.691-.9-8.318-1.293-8.707a1 1 0 00-1.154-.188zm-7.6 15.86a8.594 8.594 0 015.44-8.046 1 1 0 10-.788-1.838 10.363 10.363 0 00-6.393 7.667 6.59 6.59 0 01-.494-3.777c.4-2 1.989-3.706 4.728-5.076l5.03-2.515A29.2 29.2 0 0121 12c0 4.063-3.06 6.67-8.046 6.965zM3.523 5.38A29.2 29.2 0 003 12a6.386 6.386 0 004.366 6.212 1 1 0 11-.732 1.861A8.377 8.377 0 011 12c0-6.691.9-8.318 1.293-8.707a1 1 0 011.154-.188l6 3A1 1 0 018.553 7.9z">
        </path>
      </svg>
      <h2 class="pl-5 text-lg font-medium text-slate-800 dark:text-slate-200">
        Chats
        <span class="mx-2 rounded-full bg-blue-600 px-2 py-1 text-xs text-slate-300 inline-block scale-[.85]">
          <%= @count %>
        </span>
      </h2>
    </div>
    """
  end

  defp theme_switcher(assigns) do
    ~H"""
    <div phx-click-away={JS.add_class("hidden", to: "#themes")}>
      <button onclick="this.nextElementSibling.classList.toggle('hidden')" class="pl-1">
        <.icon
          :for={theme <- @themes}
          :if={theme.name == @current_theme}
          name={theme.icon}
          class={[
            "w-5 h-5",
            if(theme.name == "light", do: "scale-110"),
            if(@selected_theme == "system",
              do: "text-slate-800 dark:text-slate-200",
              else: "text-blue-600"
            )
          ]}
        />
      </button>
      <ul
        id="themes"
        phx-hook="SwitchTheme"
        class="hidden absolute z-50 bg-white rounded-lg ring-1 ring-slate-900/10 shadow-lg overflow-hidden w-32 py-1 text-sm text-slate-700 font-semibold dark:bg-slate-800 dark:ring-0 dark:highlight-white/5 dark:text-slate-300 mt-2"
      >
        <li
          :for={theme <- @themes}
          phx-click={
            JS.dispatch("switch-theme", detail: %{name: theme.name})
            |> JS.add_class("hidden", to: "#themes")
          }
          phx-target={@myself}
          class={[
            "py-1 px-2 flex items-center cursor-pointer hover:bg-slate-50 dark:hover:bg-slate-600/30",
            if(theme.name == @selected_theme, do: "text-blue-600 dark:text-blue-600")
          ]}
        >
          <.icon
            name={theme.icon}
            class={[
              "w-5 h-5 mr-2 text-slate-400 dark:text-slate-500",
              if(theme.name == @selected_theme, do: "text-blue-600 dark:text-blue-600"),
              if(theme.name == "light", do: "scale-110")
            ]}
          /> <%= theme.text %>
        </li>
      </ul>
    </div>
    """
  end

  defp new_chat(assigns) do
    ~H"""
    <div class="mx-2 mt-8">
      <button
        phx-click="new_chat"
        phx-target={@myself}
        class="flex w-full gap-x-4 rounded-lg border border-slate-300 p-4 text-left text-sm font-medium text-slate-700 transition-colors duration-200 hover:bg-slate-200 focus:outline-none dark:border-slate-700 dark:text-slate-200 dark:hover:bg-slate-800"
      >
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
          <path d="M12 5l0 14"></path>
          <path d="M5 12l14 0"></path>
        </svg>
        New Chat
      </button>
    </div>
    """
  end

  defp settings(assigns) do
    ~H"""
    <div class="mt-auto w-full space-y-4 px-2 py-4">
      <button class="flex w-full gap-x-2 rounded-lg px-3 py-2 text-left text-sm font-medium text-slate-700 transition-colors duration-200 hover:bg-slate-200 focus:outline-none dark:text-slate-200 dark:hover:bg-slate-800">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          fill="none"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
          <path d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0"></path>
          <path d="M12 10m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"></path>
          <path d="M6.168 18.849a4 4 0 0 1 3.832 -2.849h4a4 4 0 0 1 3.834 2.855"></path>
        </svg>
        User
      </button>
      <button class="flex w-full gap-x-2 rounded-lg px-3 py-2 text-left text-sm font-medium text-slate-700 transition-colors duration-200 hover:bg-slate-200 focus:outline-none dark:text-slate-200 dark:hover:bg-slate-800">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          fill="none"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
          <path d="M19.875 6.27a2.225 2.225 0 0 1 1.125 1.948v7.284c0 .809 -.443 1.555 -1.158 1.948l-6.75 4.27a2.269 2.269 0 0 1 -2.184 0l-6.75 -4.27a2.225 2.225 0 0 1 -1.158 -1.948v-7.285c0 -.809 .443 -1.554 1.158 -1.947l6.75 -3.98a2.33 2.33 0 0 1 2.25 0l6.75 3.98h-.033z">
          </path>
          <path d="M12 12m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"></path>
        </svg>
        Settings
      </button>
    </div>
    """
  end

  def handle_event("new_chat", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/chats")}
  end

  def handle_event("select_chat", %{"chat_id" => chat_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/chats/#{chat_id}")}
  end

  def handle_event("delete_chat", %{"chat_id" => chat_id}, socket) do
    Chat.destroy!(%Chat{id: chat_id})

    if socket.assigns.current_chat && socket.assigns.current_chat.id == chat_id do
      {:noreply,
       socket
       |> assign(chats: Chat.list!())
       |> push_patch(to: ~p"/chats")}
    else
      {:noreply, assign(socket, chats: Chat.list!())}
    end
  end

  def handle_event("edit_chat", %{"chat_id" => chat_id}, socket) do
    {:noreply, assign(socket, editing_chat_id: chat_id)}
  end

  def handle_event("cancel_edit_chat", _, socket) do
    {:noreply, assign(socket, editing_chat_id: nil)}
  end

  def handle_event("submit_edit_chat", %{"chat_id" => chat_id, "value" => value}, socket) do
    Chat.update!(%Chat{id: chat_id}, %{title: value})

    {:noreply, assign(socket, chats: Chat.list!(), editing_chat_id: nil)}
  end

  def handle_event("switch_theme", %{"selected" => selected, "current" => current}, socket) do
    {:noreply, assign(socket, selected_theme: selected, current_theme: current)}
  end

  def mount(socket) do
    {:ok, assign(socket, themes: @themes, selected_theme: "system", current_theme: "light")}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(chats: Chat.list!(), editing_chat_id: nil)}
  end
end
