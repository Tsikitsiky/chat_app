defmodule ChatApp.Messages.ChatManagement do

  alias Ecto.Multi
  alias ChatApp.Messages.Thread
  alias ChatApp.Messages.ThreadParticipation
  alias ChatApp.Messages.ThreadReply
  alias ChatApp.Repo

  # import Ecto.Query
  def create_thread_with_initial_message(content, creator_id, author_id) do
    Multi.new()
    |> Multi.insert(:thread, fn _ ->
      Thread.changeset(%Thread{}, %{
        "subject" => content,
        "creator_id" => creator_id
      })
    end)
    |> Multi.insert(:thread_participation, fn %{thread: thread} ->
      ThreadParticipation.changeset(%ThreadParticipation{}, %{
        "thread_id" => thread.id,
        "participant_id" => creator_id
      })
    end)
    |> Multi.insert(:thread_reply, fn %{thread: thread} ->
      ThreadReply.changeset(%ThreadReply{}, %{
        "content" => content,
        "thread_id" => thread.id,
        "author_id" => author_id
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok,
       %{thread: thread, thread_participation: thread_participation, thread_reply: thread_reply}} ->
        {:ok, thread, thread_participation, thread_reply}

      {:error, :thread, changeset, _changes} ->
        {:error, changeset}

      {:error, :thread_participation, changeset, _changes} ->
        {:error, changeset}

      {:error, :thread_reply, changeset, _changes} ->
        {:error, changeset}
    end
  end

  def add_participant_to_thread(thread_id, participant_id) do
    ThreadParticipation.changeset(%ThreadParticipation{}, %{
      "thread_id" => thread_id,
      "participant_id" => participant_id
    })
    |> Repo.insert()
  end

  def add_reply_to_thread(changeset) do
    ThreadReply.changeset(%ThreadReply{}, changeset)
    |> Repo.insert()
  end
end
