defmodule LiveLlama.Chats.Chat do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: false
    end

    timestamps()
  end

  code_interface do
    define_for LiveLlama.Chats

    define :list, action: :read
    define :create
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
