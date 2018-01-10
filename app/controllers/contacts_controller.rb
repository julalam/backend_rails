class ContactsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    contacts = []
    result = Contact.where(from: params[:from], status: 'accepted')
    result.each do |contact|
      contacts << {contact: contact, sender: contact.from_user}
    end
    result = Contact.where(to: params[:from], status: 'accepted')
    result.each do |contact|
      contacts << {contact: contact, sender: contact.from_user}
    end
    requests = []
    result = Contact.where(to: params[:from], status: 'pending')
    result.each do |contact|
      requests << {contact: contact, sender: contact.from_user}
    end

    render status: :ok, json: {contacts: contacts, requests: requests}

    # contacts = Contact.all
    # render status: :ok, json: contacts
  end

  # def index
  #   contacts = []
  #   result = Contact.where(from: params[:from], status: 'accepted')
  #   result.each do |contact|
  #     contacts << contact
  #   end
  #   result = Contact.where(to: params[:from], status: 'accepted')
  #   result.each do |contact|
  #     contacts << contact
  #   end
  #   requests = []
  #   result = Contact.where(to: params[:from], status: 'pending')
  #   result.each do |contact|
  #     requests << contact
  #   end
  #
  #   render status: :ok, json: {contacts: contacts, requests: requests}
  # end

  def create
    contact = Contact.new(contact_params)
    sender = contact.from_user

    if contact.save
      render status: :ok, json: {contact: contact, sender: sender}
    else
      render status: :bad_request, json: {errors: contact.errors.messages}
    end
  end

  def update
    contact = Contact.find(params[:id])
    contact.status = params[:status]

    if contact.save
      render status: :ok, json: contact
    else
      render status: :bad_request, json: {errors: contact.errors.messages}
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:from, :to)
  end
end
