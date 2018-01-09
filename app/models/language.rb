class Language < ApplicationRecord
  # has_many :users
  # has_many :messages

  validates :name, presence: true
  validates :code, presence: true
end
