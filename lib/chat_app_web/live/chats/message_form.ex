defmodule ChatAppWeb.Chats.MessageForm do
  alias ChatApp.Messages.ChatManagement
  use ChatAppWeb, :live_component

  alias ChatApp.Users.User
  alias ChatApp.Messages.ThreadReply

  @impl true
  def update(assigns, socket) do
    # assigns |> dbg()
    socket
    |> assign(assigns)
    |> assign(:message_form, ThreadReply.changeset(%ThreadReply{}, %{}))
    |> ok()
  end

  @impl true
  def handle_event("validate", %{"thread_reply" => %{"content" => content}}, socket) do
    socket
    |> assign(
      :message_form,
      ThreadReply.changeset(%ThreadReply{}, %{"content" => content})
      |> Map.put(:action, :validate)
    )
    |> noreply()
  end

  @impl true
  def handle_event(
        "send",
        %{"thread_reply" => %{"content" => content}},
        %{assigns: %{thread_id: nil}} = socket
      ) do
    case ChatManagement.create_thread_with_initial_message(
           content,
           socket.assigns.current_user.id,
           socket.assigns.current_user.id
         ) do
      {:ok, _thread, _thread_participation, _thread_reply} ->
        socket
        |> assign(:message_form, ThreadReply.changeset(%ThreadReply{}, %{}))
        |> noreply()

      {:error, _} ->
        socket
        |> assign(:message_form, ThreadReply.changeset(%ThreadReply{}, %{"content" => content}))
        |> noreply()
    end
  end

  @impl true
  def handle_event(
        "send",
        %{"thread_reply" => %{"content" => content}},
        %{assigns: %{thread_id: thread_id}} = socket
      ) do
    dbg(thread_id)

    changeset =
      ThreadReply.changeset(%ThreadReply{}, %{
        "content" => content,
        "thread_id" => thread_id,
        "author_id" => socket.assigns.current_user.id
      })

    dbg(changeset)

    case ThreadReply.create_thread_reply(changeset) do
      {:ok, _thread_reply} ->
        socket = assign(socket, :message_form, ThreadReply.changeset(%ThreadReply{}, %{}))
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :message_form, changeset)
        {:noreply, socket}
    end

    socket
    |> noreply()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@message_form} phx-change="validate" phx-submit="send" phx-target={@myself}>
        <div class="w-full flex justify-between items-center gap-5 px-6">
          <div class="w-12 h-12 flex items-center justify-center rounded-full bg-teal h-fit text-white font-semibold">
            {User.initials(@current_user)}
          </div>
          <div class="w-full">
            <.input
              type="textarea"
              field={f[:content]}
              label="Message"
              required
            />
          </div>
          <.button type="submit" class="h-fit">Send</.button>
        </div>
      </.form>
    </div>
    """
  end
end
