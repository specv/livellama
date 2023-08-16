defmodule LiveLlama.Chats.Chat do
  use Ash.Resource

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: false
    end

    timestamps()
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
