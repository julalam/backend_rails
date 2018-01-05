require 'csv'

class LanguagesController < ApplicationController
  def index

  file = Rails.root.join('lib', 'languages.csv')

  language_failures = []
  CSV.foreach(file, :headers => true) do |row|
    language = Language.new
    language.id = row['id']
    language.name = row['name']
    language.symbol = row['symbol']
    if !language.save
      language_failures << language
    end
  end

    languages = Language.all

    render status: :ok, json: languages
  end
end
