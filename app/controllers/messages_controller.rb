require 'uri-handler'
require_dependency '../../lib/api_wrapper'

class MessagesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    if params[:from] && params[:to]
      messages = []
      result = Message.where(from: params[:from], to: params[:to])
      result.each do |message|
        messages << message
      end
      result = Message.where(from: params[:to], to: params[:from])
      result.each do |message|
        messages << message
      end
      messages = messages.sort { |a,b| a.created_at <=> b.created_at }
    else
      messages = Message.all
    end

    render status: :ok, json: messages
  end

  def create
    message = Message.new(message_params)

    message.message = APIWrapper.translate(message.text.to_uri, message.language.code.downcase)

    if message.save
      head :ok
    else
      render status: :bad_request, json: {errors: message.errors.messages}
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :from, :to, :language_id)

  end
end
