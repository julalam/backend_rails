class ContactsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :find_contact, only: [:update, :destroy]

  def create
    contact = Contact.new(contact_params)
    sender = contact.from_user

    if contact.save
      head :ok
      # render status: :ok, json: {contact: contact, sender: sender}
    else
      render status: :bad_request, json: {errors: contact.errors.messages}
    end
  end

  def update
    @contact.status = params[:status]

    if @contact.save
      render status: :ok, json: @contact
    else
      render status: :bad_request, json: {errors: @contact.errors.messages}
    end
  end

  def destroy
    if @contact.destroy
      render status: :ok, json: {status: 'deleted'}
    else
      render status: :bad_request, json: {errors: 'error'}
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:from, :to)
  end

  def find_contact
    @contact = Contact.find_by(id: params[:id])
    if !@contact
      render status: :not_found, json: {errors: 'contact not found'}
    end
    return @contact
  end

end
