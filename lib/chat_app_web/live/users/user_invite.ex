defmodule ChatAppWeb.Users.UserInvite do
  use ChatAppWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket
    |> assign(assigns)
    |> assign(:form, %{"email" => ""})
    |> ok()
  end

  @impl true
  def handle_event("validate", %{"email" => _email}, socket) do
    socket
    |> noreply()
  end

  @impl true
  def handle_event("send_invite", %{"email" => email}, socket) do
    ChatApp.Users.UserNotifier.deliver_user_invite(email, "http://localhost:4000/users/register?email=#{email}")
    socket
    |> push_patch(to: ~p"/users")
    |> put_flash(:info, "Invitation sent to #{email}")
    |> noreply()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <h2>Invite User</h2>
      </.header>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="send_invite" phx-target={@myself}>
        <.input
          type="email"
          field={f[:email]}
          label="Email"
          required
        />
        <.button type="submit">Send Invite</.button>
      </.form>
    </div>
    """
  end
end
