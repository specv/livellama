defmodule LiveLlama.Chats do
  use Ash.Api

  resources do
    registry LiveLlama.Chats.Registry
  end
end
