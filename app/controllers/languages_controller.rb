class LanguagesController < ApplicationController
  def index
    languages = Language.order(:id)

    render status: :ok, json: languages
  end
end
