class Language < ApplicationRecord
  # has_many :messages
  # has_many :users

  validates :name, presence: true
  validates :symbol, presence: true
end
