class LanguagesController < ApplicationController
  def index

    if params[:from] && params[:to]
      messages = []
      # probably from would be the user id from session
      result = Message.where(from: params[:from], to: params[:to])
      result.each do |message|
        messages << message
      end
      result = Message.where(from: params[:to], to: params[:from])
      result.each do |message|
        messages << message
      end
      messages = messages.sort { |a,b| b.created_at <=> a.created_at }
    else
      messages = Message.all
    end

    render status: :ok, json: messages
  end
end
