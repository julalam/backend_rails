class LanguagesController < ApplicationController
  def index
    languages = Language.all

    render status: :ok, json: languages
  end
end
