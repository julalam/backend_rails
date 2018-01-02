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

  private

  def user_params
    params.permit(:username, :language)
  end
end
