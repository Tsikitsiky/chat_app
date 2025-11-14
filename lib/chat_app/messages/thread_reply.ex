defmodule ChatApp.Messages.ThreadReply do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "thread_replies" do
    field :content, :string
    belongs_to :thread, ChatApp.Messages.Thread, type: Ecto.UUID
    belongs_to :author, ChatApp.Users.User, type: Ecto.UUID

    timestamps()
  end

  def changeset(thread_reply, attrs) do
    thread_reply
    |> cast(attrs, [:content, :thread_id, :author_id])
    |> validate_required([:content, :thread_id, :author_id])
  end

  def from() do
    from(m in __MODULE__, as: :thread_reply)
  end

  def get(id) do
    from(m in __MODULE__, as: :thread_reply, where: m.id == ^id)
  end

end
