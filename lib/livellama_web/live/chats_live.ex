defmodule LiveLlamaWeb.ChatsLive do
  use LiveLlamaWeb, :live_view
  alias LiveLlama.Chats.Chat

  def render(assigns) do
    ~H"""
    <div class="flex dark:bg-slate-700">
      <div class="w-64 border-r border-slate-300 dark:border-slate-700">
        <.live_component
          module={LiveLlamaWeb.ChatsLive.SidebarComponent}
          id="sidebar"
          current_chat={@current_chat}
        />
      </div>
      <div class="flex-grow">
        <.live_component
          module={LiveLlamaWeb.ChatsLive.PromptContainerComponent}
          id="prompt_container"
        />
      </div>
    </div>
    """
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    assign(socket, current_chat: nil)
  end

  def apply_action(socket, :chat, %{"chat_id" => chat_id}) do
    assign(socket, current_chat: Chat.get_by_id!(chat_id))
  end
end
