defmodule ChatAppWeb.Chats.ChatLive do
  use ChatAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:active_nav_item, :chats)
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
