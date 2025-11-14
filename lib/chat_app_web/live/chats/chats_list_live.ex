defmodule ChatAppWeb.Chats.ChatsListLive do
  use ChatAppWeb, :live_view

  alias ChatApp.Messages.Thread

  @impl true
  def mount(_params, _session, socket) do

    socket
    |> assign(:page_title, "Chats")
    |> assign(:active_nav_item, :chats)
    |> assign(:chat_list, Thread.list_threads_for_user(socket.assigns.current_user.id))
    |> ok()
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket
    |> noreply()
  end
end
