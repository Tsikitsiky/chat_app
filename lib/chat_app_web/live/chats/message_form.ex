defmodule ChatAppWeb.Chats.MessageForm do
  use ChatAppWeb, :live_component

  alias ChatApp.Messages.ThreadReply
  alias ChatApp.Messages.ChatManagement

  import ChatAppWeb.CoreComponents

  @impl true
  def update(assigns, socket) do
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
           socket.assigns.participant_ids
         ) do
      {:ok, _thread, _thread_reply, _thread_participation} ->
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
    changeset =
      ThreadReply.changeset(%ThreadReply{}, %{
        "content" => content,
        "thread_id" => thread_id,
        "author_id" => socket.assigns.current_user.id
      })

    case ChatManagement.add_reply_to_thread(changeset) do
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
        <.initials_rounder user={@current_user} />
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
