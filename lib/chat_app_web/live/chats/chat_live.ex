defmodule ChatAppWeb.Chats.ChatLive do
  use ChatAppWeb, :live_view

  alias Phoenix.PubSub

  import ChatAppWeb.Components.Messages
  import Ecto.Query

  @impl true
  def mount(%{"user_id" => user_id}, _session, socket) do
    # subscribe_to_pubsub(socket)

    socket
    |> assign(:active_nav_item, :chats)
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:participant_ids, [user_id, socket.assigns.current_user.id])
    |> ok()
  end

  def mount(%{"chat_id" => thread_id}, _session, socket) do
    thread =
      ChatApp.Messages.Thread.get(thread_id)
      |> preload([:participants])
      |> ChatApp.Repo.one()

    socket = socket |> assign(:thread_id, thread_id)
    subscribe_to_pubsub(socket)

    socket
    |> assign(:active_nav_item, :chats)
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:participant_ids, Enum.map(thread.participants, & &1.id))
    |> load_messages(thread_id)
    |> ok()
  end

  @impl true
  def handle_info(%{type: :new_message, message: message}, socket) do
    socket
    |> load_messages(message.thread_id)
    |> noreply()
  end

  def subscribe_to_pubsub(socket) do
    connected?(socket) &&
      PubSub.subscribe(
        ChatApp.PubSub,
        ChatApp.Topics.new_message_for_a_thread(socket.assigns.thread_id)
      )
  end

  @impl true
  def handle_params(params, _uri, socket) do
    thread_id = Map.get(params, "chat_id")

    socket
    |> assign(:thread_id, thread_id)
    |> noreply()
  end

  def load_messages(socket, thread_id) do
    messages =
      ChatApp.Messages.ThreadReply.from()
      |> where([tr], tr.thread_id == ^thread_id)
      |> order_by([tr], asc: tr.inserted_at)
      |> preload([:author])
      |> ChatApp.Repo.all()

    socket
    |> assign(:messages, messages)
  end
end
