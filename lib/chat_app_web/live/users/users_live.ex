defmodule ChatAppWeb.Users.UsersLive do
  use ChatAppWeb, :live_view
  alias ChatApp.Users
  # alias ChatApp.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "User Management")
    |> assign(:active_nav_item, :users)
    |> assign(:users, Users.list_users() |> Enum.filter(& &1.id !== socket.assigns.current_user.id))
    |> assign(:show_invite_modal, false)
    |> ok()
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket
    |> noreply()
  end

  @impl true
  def handle_event("open_invite_modal", _params, socket) do
    socket
    |> assign(:live_action, :invite)
    |> noreply()
  end

  @impl true
  def handle_event("open_a_discussion", %{"user_id" => user_id}, socket) do
    dbg(user_id)
    socket
    |> push_navigate(to: ~p"/chats/new/#{user_id}")
    |> noreply()
  end
end
