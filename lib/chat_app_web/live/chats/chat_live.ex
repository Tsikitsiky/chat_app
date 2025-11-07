defmodule ChatAppWeb.Chats.ChatLive do
  use ChatAppWeb, :live_view

  @impl true
  def mount(%{"user_id" => user_id}, _session, socket) do
    dbg(user_id)

    socket
    |> assign(:active_nav_item, :chats)
    |> assign(:current_user, socket.assigns.current_user)
    |> ok()
  end

  def mount(%{"chat_id" => thread_id}, session, socket) do
    dbg(thread_id)

    socket
    |> assign(:active_nav_item, :chats)
    |> assign(:thread_id, thread_id)
    |> assign(:current_user, session["current_user"])
    |> ok()
  end

  @impl true
  def handle_params(params, _uri, socket) do
    thread_id = Map.get(params, "chat_id")

    socket
    |> assign(:thread_id, thread_id)
    |> noreply()
  end
end
