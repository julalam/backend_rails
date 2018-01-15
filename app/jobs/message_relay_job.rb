class MessageRelayJob < ApplicationJob
  def perform(message)
    ActionCable.server.broadcast "messages_#{message.to}", message
    ActionCable.server.broadcast "messages_#{message.from}", message
  end
end
