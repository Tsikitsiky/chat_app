defmodule ChatAppWeb.Components.Messages do
  use Phoenix.Component

  import ChatAppWeb.CoreComponents, only: [initials_rounder: 1]

  attr :message, :map, required: true
  attr :current_user, :map, required: true

  def message_card(assigns) do
    ~H"""
    <article class="flex flex-col gap-2 py-4 px-12">
      <div class={"flex mb-4 gap-3 " <> if @message.author.id == @current_user.id, do: "flex-row-reverse", else: "flex-row"}>
        <.initials_rounder user={@message.author} />
        <div class="p-4 border rounded-lg bg-teal/50">
          <p>{@message.content}</p>
        </div>
      </div>
      <%!-- <span class="text-sm text-gray-600">- {@message.author.first_name}</span> --%>
    </article>
    """
  end
end
