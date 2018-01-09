class LanguagesController < ApplicationController
  def index
    # languages = Language.all.sort
    languages = Language.order(:id)

    render status: :ok, json: languages
  end
end
