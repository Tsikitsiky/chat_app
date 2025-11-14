defmodule ChatApp.Messages.ChatManagement do
  alias Ecto.Multi
  alias ChatApp.Messages.Thread
  alias ChatApp.Messages.ThreadParticipation
  alias ChatApp.Messages.ThreadReply
  alias ChatApp.Repo

  # import Ecto.Query
  def create_thread_with_initial_message(content, creator_id, participants) do
    Multi.new()
    |> Multi.insert(:thread, fn _ ->
      Thread.changeset(%Thread{}, %{
        subject: content,
        creator_id: creator_id
      })
    end)
    |> Multi.run(:create_thread_participations, fn _repo, %{thread: thread} ->
      participations =
        participants
        |> Enum.map(fn participant_id ->
          %ThreadParticipation{}
          |> ThreadParticipation.changeset(%{
            thread_id: thread.id,
            participant_id: participant_id
          })
          |> Repo.insert!()
        end)

      {:ok, participations}
    end)
    |> Multi.insert(:thread_reply, fn %{thread: thread} ->
      ThreadReply.changeset(%ThreadReply{}, %{
        content: content,
        thread_id: thread.id,
        author_id: creator_id
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok,
       %{
         thread: thread,
         thread_reply: thread_reply,
         create_thread_participations: thread_participation
       }} ->
        notify_about_new_message(thread_reply)
        {:ok, thread, thread_reply, thread_participation}

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
      thread_id: thread_id,
      participant_id: participant_id
    })
    |> Repo.insert()
  end

  def add_reply_to_thread(changeset) do
    changeset
    |> Repo.insert()
    |> case do
      {:ok, thread_reply} ->
        notify_about_new_message(thread_reply)

        {:ok, thread_reply}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def notify_about_new_message(thread_reply) do
    Phoenix.PubSub.broadcast(
      ChatApp.PubSub,
      ChatApp.Topics.new_message_for_a_thread(thread_reply.thread_id),
      ChatApp.Events.new_message(thread_reply)
    )
  end
end
