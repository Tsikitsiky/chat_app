defmodule ChatApp.Repo.Migrations.AddThreadsAndThreadRepliesTables do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :subject, :string, null: false
      add :creator_id, references(:users, type: :uuid, on_delete: :nothing), null: false

      timestamps()
    end

    create table(:thread_replies, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :content, :text, null: false
      add :thread_id, references(:threads, type: :uuid, on_delete: :nothing), null: false
      add :author_id, references(:users, type: :uuid, on_delete: :nothing), null: false

      timestamps()
    end

    create table(:thread_participations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :thread_id, references(:threads, type: :uuid, on_delete: :nothing), null: false
      add :participant_id, references(:users, type: :uuid, on_delete: :nothing), null: false

      add :last_read_reply_id, references(:thread_replies, type: :uuid, on_delete: :nothing)

      timestamps()
    end

  end
end
