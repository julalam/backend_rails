class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    user = User.find_by(id: params[:user])

    users = [] # more users and sent requests
    contacts = [] #friends and received requests

    more_users = User.all - [user]

    user.from_contacts.each do |contact|
      if contact.status == 'pending'
        users << {user: contact.to_user, status: 'sent_request'}
        more_users -= [contact.to_user]
      elsif contact.status == 'accepted'
        contacts << {user: contact.to_user, status: 'friend'}
        more_users -= [contact.to_user]
      end
    end

    user.to_contacts.each do |contact|
      if contact.status == 'pending'
        contacts << {user: contact.from_user, status: 'recieved_request', contact: contact}
        more_users -= [contact.from_user]
      elsif contact.status == 'accepted'
        contacts << {user: contact.from_user, status: 'friend'}
        more_users -= [contact.from_user]
      end
    end

    more_users.each do |contact|
      users << {user: contact, status: 'user'}
    end

    # users = users.sort_by { |contact| contact["user".to_sym].username }

    if !params[:search]
      result = contacts.sort_by{ |contact| contact[:status] }
    end

    render status: :ok, json: result
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
