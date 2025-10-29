defmodule ChatAppWeb.Chats.MessageForm do
  use ChatAppWeb, :live_component

  alias ChatApp.Users.User
  alias ChatApp.Messages.ThreadReply

  def update(assigns, socket) do
    assigns |> dbg()
    socket
    |> assign(assigns)
    |> assign(:message_form, ThreadReply.changeset(%ThreadReply{}, %{}))
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@message_form} phx-change="validate" phx-submit="send" phx-target={@myself}>
        <div class="w-full flex justify-between items-center gap-5 px-6">
          <div class="px-5 py-3 rounded-full bg-teal h-fit text-white">
            {User.initials(@current_user)}
          </div>
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
