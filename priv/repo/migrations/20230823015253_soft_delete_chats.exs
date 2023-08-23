defmodule LiveLlama.Repo.Migrations.SoftDeleteChats do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:chats) do
      add :archived_at, :utc_datetime_usec
    end
  end

  def down do
    alter table(:chats) do
      remove :archived_at
    end
  end
end