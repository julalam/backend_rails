class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
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
        requests << {user: contact.from_user, status: 'received_request', contact: contact, avatar: contact.from_user.avatar.url}
      elsif contact.status == 'accepted'
        friends << contact.from_user
      end
    end

    requests = requests.sort { |a,b| a[:contact].created_at <=> b[:contact].created_at }

    contacts = []

    friends.each do |friend|
      last_message_from = friend.from_messages
        .select { |message| message.to_user.id == user.id }
        .sort { |a,b| a.created_at <=> b.created_at }
        .last

      last_message_to = friend.to_messages
        .select { |message| message.from_user.id == user.id }
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

      contacts << { user: friend, status: 'friend', last_message: message, avatar: friend.avatar.url, language: friend.language.name }
    end

    contacts_with_message = contacts
    .select { |contact| contact[:last_message] != nil }
    .sort { |a,b| b[:last_message].created_at <=> a[:last_message].created_at }

    contacts_with_no_message = contacts
    .select { |contact| contact[:last_message] == nil }
    .sort { |contact| contact[:user].username }

    result = requests + contacts_with_message + contacts_with_no_message

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
          contacts << {user: contact.to_user, status: 'friend', avatar: contact.to_user.avatar.url, language: contact.language.name }
        end
      end
    end

    user.to_contacts.each do |contact|
      if contact.status == 'pending'
        if found?(contact.from_user)
          more_users -= [contact.from_user]
          requests << {user: contact.from_user, status: 'received_request', contact: contact, avatar: contact.from_user.avatar.url}
        end
      elsif contact.status == 'accepted'
        if found?(contact.from_user)
          more_users -= [contact.from_user]
          contacts << {user: contact.from_user, status: 'friend', avatar: contact.from_user.avatar.url, language: contact.language.name }
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
          users << {user: contact.to_user, status: 'sent_request', avatar: contact.to_user.avatar.url, contact: contact}
        end
      end
    end

    more_users.each do |user|
      users << {user: user, status: 'user', avatar: user.avatar.url}
    end

    users = users.sort_by{ |contact| contact[:user].username }

    result = requests + contacts + users

    render status: :ok, json: result
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:logged_in_user] = user.id
      user.state = 'online'
      render status: :ok, json: {session: user, avatar: user.avatar.url, language: user.language.name}
    else
      render status: :bad_request, json: {errors: user.errors.messages}
    end
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(user_update_params)

    if user.save
      render status: :ok, json: {user: user, avatar: user.avatar.url, language: user.language.name}
    else
      render status: :bad_request, json: {errors: user.errors.messages}
    end
  end

  def login
    user = User.find_by(username: params[:data][:username])

    if user
      session[:logged_in_user] = user.id
      user.state = 'online'
      render status: :ok, json: {session: user, avatar: user.avatar.url, language: user.language.name}
    else
      render status: :ok, json: {user: nil}
    end
  end

  def logout
    user = User.find_by(id: params[:user])
    user.state = 'offline'
    session[:logged_in_user] = nil
    render status: :ok, json: {session: nil, avatar: nil}
  end

  private

  def user_params
    params.permit(:username, :email, :password, :country, :language_id, :avatar)
  end

  def user_update_params
    params.permit(:avatar, :email, :country, :language_id)
  end

  def found?(user)
    return user.username.downcase.include?(params[:query].downcase)
  end
end
