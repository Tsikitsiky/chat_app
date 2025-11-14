defmodule ChatApp.Messages.ThreadParticipation do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "thread_participations" do
    belongs_to :thread, ChatApp.Messages.Thread, type: :binary_id
    belongs_to :participant, ChatApp.Users.User, type: :binary_id
    belongs_to :last_read_reply, ChatApp.Messages.ThreadReply, type: :binary_id

    timestamps()
  end

  def changeset(thread_participation, attrs) do
    thread_participation
    |> cast(attrs, [:thread_id, :participant_id, :last_read_reply_id])
    |> validate_required([:thread_id, :participant_id])
  end

  def from() do
    from(tp in __MODULE__, as: :participation)
  end

  def get(id) do
    from(tp in __MODULE__, as: :participation, where: tp.id == ^id)
  end
end
