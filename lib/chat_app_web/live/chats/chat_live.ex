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

  def mount(%{"chat_id" => chat_id}, session, socket) do
    dbg(chat_id)

    socket
    |> assign(:active_nav_item, :chats)
    |> assign(:current_user, session["current_user"])
    |> ok()
  end

  @impl true
  def handle_params(params, _uri, socket) do
    chat_id = Map.get(params, "chat_id")

    socket
    |> assign(:chat_id, chat_id)
    |> noreply()
  end
end
