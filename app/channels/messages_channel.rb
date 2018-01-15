class MessagesChannel < ApplicationCable::Channel
  def subscribed
      stream_from "messages_#{params[:id]}"
  end
 # adfasdfs
  # def receive(data)
  #   # save message and not use messages_controller
  # end
end
