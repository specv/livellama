defmodule LiveLlamaWeb.ChatsLive do
  use LiveLlamaWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex dark:bg-slate-700">
      <div class="w-64 border-r border-slate-300 dark:border-slate-700">
        <.live_component module={LiveLlamaWeb.ChatsLive.SidebarComponent} id="sidebar" />
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
end
