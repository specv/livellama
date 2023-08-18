defmodule LiveLlama.Chats.Chat do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: false
    end

    timestamps()
  end

  relationships do
    has_many :messages, LiveLlama.Chats.Message do
      sort inserted_at: :asc
    end
  end

  code_interface do
    define_for LiveLlama.Chats

    define :create
    define :list, action: :list
    define :get_by_id, args: [:id]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :list do
      prepare build(sort: [inserted_at: :desc])
    end

    read :get_by_id do
      argument :id, :string do
        allow_nil? false
      end

      get? true

      prepare build(load: [:messages], sort: [inserted_at: :desc])

      filter expr(id == ^arg(:id))
    end
  end

  postgres do
    table "chats"
    repo LiveLlama.Repo
  end
end
