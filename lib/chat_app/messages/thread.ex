defmodule ChatApp.Messages.Thread do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "threads" do
    field :subject, :string
    belongs_to :creator, ChatApp.Users.User, type: Ecto.UUID

    has_many :thread_replies, ChatApp.Messages.ThreadReply
    has_many :participations, ChatApp.Messages.ThreadParticipation
    has_many :participants, through: [:participations, :participant]

    timestamps()
  end

  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:subject, :creator_id])
    |> validate_required([:subject, :creator_id])
  end

  def from() do
    from(t in __MODULE__, as: :thread)
  end

  def get(id) do
    from(t in __MODULE__, as: :thread, where: t.id == ^id)
  end

  def create_thread(changeset) do
    changeset
    |> ChatApp.Repo.insert()
  end

  def list_threads_for_user(user_id) do
    from(t in __MODULE__,
      join: p in ChatApp.Messages.ThreadParticipation,
      on: p.thread_id == t.id,
      where: p.participant_id == ^user_id,
      order_by: [desc: t.inserted_at],
      distinct: t.id,
      select: t
    )
    |> ChatApp.Repo.all()
  end
end
