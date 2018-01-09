require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FILE = Rails.root.join('db', 'languages.csv')

language_failures = []
CSV.foreach(FILE, :headers => true) do |row|
  language = Language.new
  language.id = row['id']
  language.name = row['name']
  language.code = row['code']
  if !language.save
    language_failures << language
  end
end
