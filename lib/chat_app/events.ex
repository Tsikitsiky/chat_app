defmodule ChatApp.Events do
alias ChatApp.Messages.ThreadReply

  def new_message(message = %ThreadReply{}) do
    %{type: :new_message, message: message}
  end
end
