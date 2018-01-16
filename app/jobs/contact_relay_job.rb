class ContactRelayJob < ApplicationJob
  def perform(contact)

    ActionCable.server.broadcast "contacts_#{contact.to}", user: contact.from_user, status: contact.status == 'pending' ? 'received_request' : 'friend', contact: contact.status == 'pending' ? contact : nil
    ActionCable.server.broadcast "contacts_#{contact.from}", user: contact.to_user, status: contact.status == 'pending' ? 'sent_request' : 'friend', contact: contact.status == 'pending' ? contact : nil
  end
end
