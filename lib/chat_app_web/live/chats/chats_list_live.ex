defmodule ChatAppWeb.Chats.ChatsListLive do
  use ChatAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "Chats")
    |> assign(:active_nav_item, :chats)
    |> ok()
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket
    |> noreply()
  end
end
