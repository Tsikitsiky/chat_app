defmodule ChatAppWeb.NavLive do
  use ChatAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> ok()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <nav>
      <ul class="flex bg-teal h-screen flex-col w-48 p-4 text-white space-y-4">
        <li><.link navigate={~p"/users"}>Users</.link></li>
        <li><.link navigate={~p"/chats"}>Chats</.link></li>
      </ul>
    </nav>
    """
  end

end
