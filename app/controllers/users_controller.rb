class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    users = User.all

    render status: :ok, json: users
  end

  def create
    user = User.new(user_params)

    if user.save
      render status: :ok, json: {id: user.id}
    else
      render status: :bad_request, json: {errors: user.errors.messages}
    end
  end

  def login
    username = params[:username]
    user = User.find_by(username: username)

    if user
      session[:logged_in_user] = user.id
      # any flash messages needed?
    else
      @user = User.new(username: username)
      if @user.save
        session[:logged_in_user] = @user.id
        # flash messages needed?
      else
         # errors if new user wasn't created
       end
     end
  end

  def logout
    session[:logged_in_user] = nil
    # need to send anything to react??
  end

  private

  def user_params
    params.permit(:username, :language)
  end
end
