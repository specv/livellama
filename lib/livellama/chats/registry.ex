defmodule LiveLlama.Chats.Registry do
  use Ash.Registry

  entries do
    entry LiveLlama.Chats.Chat
    entry LiveLlama.Chats.Message
  end
end
