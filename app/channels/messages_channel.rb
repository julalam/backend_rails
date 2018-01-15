class MessagesChannel < ApplicationCable::Channel
  def subscribed
      stream_from "messages_#{params[:id]}"
  end
end
