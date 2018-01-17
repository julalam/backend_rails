class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    # user = User.find_by(id: session[:logged_in_user])
    user = User.find_by(id: params[:user])

    requests = []
    friends = []

    user.from_contacts.each do |contact|
      if contact.status == 'accepted'
        friends << contact.to_user
      end
    end

    user.to_contacts.each do |contact|
      if contact.status == 'pending'
        requests << {user: contact.from_user, status: 'received_request', contact: contact}
      elsif contact.status == 'accepted'
        friends << contact.from_user
      end
    end

    # TODO sort by most recent order?
    requests = requests.sort_by { |contact| contact[:user].username }

    contacts = []
    friends.each do |friend|
      last_message_from = friend.from_messages
        .select { |message| message.from_user.id == friend.id }
        .sort { |a,b| a.created_at <=> b.created_at }
        .last

      last_message_to = friend.to_messages
        .select { |message| message.to_user.id == friend.id }
        .sort { |a,b| a.created_at <=> b.created_at }
        .last

      message = nil
      if last_message_to && last_message_from
        message = last_message_to.created_at > last_message_from.created_at ? last_message_to : last_message_from
      elsif last_message_to
        message = last_message_to
      elsif last_message_from
        message = last_message_from
      end

      contacts << { user: friend, status: 'friend', last_message: message }
    end

    contacts = contacts.sort_by { |contact| contact[:status] }

    result = requests + contacts

    render status: :ok, json: result
  end

  def search
    user = User.find_by(id: params[:user])

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
          requests << {user: contact.from_user, status: 'received_request', contact: contact}
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

    more_users.each do |user|
      users << {user: user, status: 'user'}
    end

    users = users.sort_by{ |contact| contact[:user].username }

    result = requests + contacts + users

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
    user = User.find_by(username: params[:data][:username])

    if user
      session[:logged_in_user] = user.id
      render status: :ok, json: {session: user}
    else
      render status: :ok, json: {user: nil}
    end
  end

  def logout
    session[:logged_in_user] = nil
    render status: :ok, json: {session: nil}
  end

  private

  def user_params
    params.permit(:username, :email, :password, :country, :language)
  end

  def found?(user)
    return user.username.downcase.include?(params[:query].downcase)
  end
end
