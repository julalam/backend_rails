class OnlineStateRelayJob < ApplicationJob
  def perform(user)
    user.from_contacts.each do |contact|
      if contact.status == 'accepted'
        ActionCable.server.broadcast "online_state_#{contact.to}", id: user.id, state: user.state
      end
    end
    user.to_contacts.each do |contact|
      if contact.status == 'accepted'
        ActionCable.server.broadcast "online_state_#{contact.from}", id: user.id, state: user.state
      end
    end
  end
end
