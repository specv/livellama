defmodule LiveLlama.Chats.Message do
  defmodule Role do
    use Ash.Type.Enum, values: [:system, :user, :assistant]
  end

  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key :id

    attribute :role, :atom do
      allow_nil? false
      constraints one_of: Role.values()
    end

    attribute :content, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: true
      default ""
    end

    attribute :error, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: true
      default ""
    end

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :chat, LiveLlama.Chats.Chat do
      allow_nil? false
    end
  end

  code_interface do
    define_for LiveLlama.Chats

    define :create, action: :create_with_relation
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :create_with_relation do
      argument :chat_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:chat_id, :chat, type: :append)
    end
  end
end
