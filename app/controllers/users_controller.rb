class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    user = User.find_by(id: params[:user])

    sent_requests = []
    user.from_contacts.each do |contact|
      if contact.status == 'pending'
        sent_requests << contact.to_user
      end
    end

    received_requests = []
    user.to_contacts.each do |contact|
      if contact.status == 'pending'
        received_requests << contact.from_user
      end
    end

    contact_list = []
    user.from_contacts.each do |contact|
      if contact.status == 'accepted'
        contact_list << contact.to_user
      end
    end
    user.to_contacts.each do |contact|
      if contact.status == 'accepted'
        contact_list << contact.from_user
      end
    end

    more_users = User.all - sent_requests - received_requests - contact_list - [user]

    render status: :ok, json: {sent_requests: sent_requests, received_requests: received_requests, contact_list: contact_list, more_users: more_users}
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:logged_in_user] = user.id
      render status: :ok, json: {session: user}
    else
      render status: :bad_request, json: {errors: user.errors.messages}
    end
  end

  def login
    username = params[:username]
    user = User.find_by(username: username)

    if user
      session[:logged_in_user] = user.id
      render status: :ok, json: {session: user}
    else
      render status: :bad_request, json: {user: nil}
    end
  end

  def logout
    session[:logged_in_user] = nil
    render status: :ok, json: {session: nil}
  end

  private

  def user_params
    params.permit(:username, :language)
  end
end
