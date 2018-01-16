class ContactsChannel < ApplicationCable::Channel
  def subscribed
      stream_from "contacts_#{params[:id]}"
  end
end
