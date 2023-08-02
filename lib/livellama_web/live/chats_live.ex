defmodule LiveLlamaWeb.ChatsLive do
  use LiveLlamaWeb, :live_view

  def render(assigns) do
    ~H"""
    <.live_component module={LiveLlamaWeb.ChatsLive.SidebarComponent} id="sidebar" />
    <.live_component module={LiveLlamaWeb.ChatsLive.PromptMessagesComponent} id="prompt_messages" />
    """
  end
end
