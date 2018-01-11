class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    # user = User.find_by(id: session[:logged_in_user])
    user = User.find_by(id: params[:user])

    if !params[:search] || params[:search] == ''
      contacts = []
      requests = []

      user.from_contacts.each do |contact|
        if contact.status == 'accepted'
          contacts << {user: contact.to_user, status: 'friend'}
        end
      end

      user.to_contacts.each do |contact|
        if contact.status == 'pending'
          requests << {user: contact.from_user, status: 'received_request', contact: contact}
        elsif contact.status == 'accepted'
          contacts << {user: contact.from_user, status: 'friend'}
        end
      end

      contacts = contacts.sort_by { |contact| contact[:status] }
      requests = requests.sort_by { |contact| contact[:status] }

      result = requests + contacts
    else
      contacts = []
      requests = []
      more_users = []

      User.all.each do |user|
        if found?(user)
          more_users << user
        end
      end

      more_users -= [user]

      user.from_contacts.each do |contact|
        if contact.status == 'accepted'
          if found?(contact.to_user)
            more_users -= [contact.to_user]
            contacts << {user: contact.to_user, status: 'friend'}
          end
        end
      end

      user.to_contacts.each do |contact|
        if contact.status == 'pending'
          if found?(contact.from_user)
            more_users -= [contact.from_user]
            requests << {user: contact.from_user, status: 'recieved_request', contact: contact}
          end
        elsif contact.status == 'accepted'
          if found?(contact.from_user)
            more_users -= [contact.from_user]
            contacts << {user: contact.from_user, status: 'friend'}
          end
        end
      end

      contacts = contacts.sort_by { |contact| contact[:user].username }
      requests = requests.sort_by { |contact| contact[:user].username }

      users = []

      user.from_contacts.each do |contact|
        if contact.status == 'pending'
          if found?(contact.to_user)
            more_users -= [contact.to_user]
            users << {user: contact.to_user, status: 'sent_request'}
          end
        end
      end

      more_users.each do |contact|
        users << {user: contact, status: 'user'}
      end

      users = users.sort_by{ |contact| contact[:user].username }

      result = requests + contacts + users
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

  def found?(user)
    return user.username.downcase.include?(params[:search].downcase)
  end
end
