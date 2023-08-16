defmodule LiveLlama.Chats.Message do
  defmodule Role do
    use Ash.Type.Enum, values: [:system, :user, :assistant]
  end

  use Ash.Resource

  attributes do
    uuid_primary_key :id

    attribute :role, :atom do
      allow_nil? false
      constraints one_of: Role.values()
    end

    attribute :content, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: false
      default ""
    end

    attribute :error, :string do
      allow_nil? false
      constraints trim?: false, allow_empty?: false
      default ""
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
