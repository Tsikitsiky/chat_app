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
    |> cast(attrs, [:subject, :department_id, :department_document_data_id, :metadata])
    |> validate_required([:subject, :department_id, :department_document_data_id])
  end

  def from() do
    from(t in __MODULE__, as: :thread)
  end

  def get(id) do
    from(t in __MODULE__, as: :thread, where: t.id == ^id)
  end
end
