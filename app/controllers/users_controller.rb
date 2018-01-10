class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    user = User.find_by(id: params[:user])

    users = []
    more_users = User.all - [user]

    user.from_contacts.each do |contact|
      if contact.status == 'pending'
        users << {user: contact.to_user, status: 'sent_request'}
        more_users -= [contact.to_user]
      end
    end

    received_requests = []
    user.to_contacts.each do |contact|
      if contact.status == 'pending'
        users << {user: contact.from_user, status: 'recieved_request'}
        more_users -= [contact.from_user]
      end
    end

    contact_list = []
    user.from_contacts.each do |contact|
      if contact.status == 'accepted'
        users << {user: contact.to_user, status: 'friend'}
        more_users -= [contact.to_user]
      end
    end
    user.to_contacts.each do |contact|
      if contact.status == 'accepted'
        users << {user: contact.from_user, status: 'friend'}
        more_users -= [contact.from_user]
      end
    end

    more_users.each do |contact|
      users << {user: contact, status: 'user'}
    end

    users = users.sort_by { |contact| contact["user".to_sym].username }

    render status: :ok, json: users
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
