defmodule LiveLlama.Repo.Migrations.AddChatsAndMessages do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:messages, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :role, :text, null: false
      add :content, :text, null: false, default: ""
      add :error, :text, null: false, default: ""
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :chat_id, :uuid, null: false
    end

    create table(:chats, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
    end

    alter table(:messages) do
      modify :chat_id,
             references(:chats,
               column: :id,
               name: "messages_chat_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:chats) do
      add :title, :text, null: false
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")
    end
  end

  def down do
    alter table(:chats) do
      remove :updated_at
      remove :inserted_at
      remove :title
    end

    drop constraint(:messages, "messages_chat_id_fkey")

    alter table(:messages) do
      modify :chat_id, :uuid
    end

    drop table(:chats)

    drop table(:messages)
  end
end