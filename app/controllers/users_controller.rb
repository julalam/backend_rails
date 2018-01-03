class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    users = User.all

    render status: :ok, json: users
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:logged_in_user] = user.id
      render status: :ok, json: {user: user, session: user.id}
    else
      render status: :bad_request, json: {errors: user.errors.messages}
    end
  end

  def login
    username = params[:username]
    user = User.find_by(username: username)

    if user
      session[:logged_in_user] = user.id
      render status: :ok, json: {user: user, session: user.id}
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
