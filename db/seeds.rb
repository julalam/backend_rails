require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

LANGUAGE_FILE = Rails.root.join('db', 'languages.csv')

language_failures = []
CSV.foreach(LANGUAGE_FILE, :headers => true) do |row|
  language = Language.new
  language.id = row['id']
  language.name = row['name']
  language.native_name = row['native_name']
  language.code = row['code']
  if !language.save
    language_failures << language
  end
end

COUNTRY_FILE = Rails.root.join('db', 'countries.csv')

countries_failures = []
CSV.foreach(COUNTRY_FILE, :headers => true) do |row|
  country = Country.new
  country.id = row['id']
  country.name = row['name']
  if !country.save
    countries_failures << country
  end
end
