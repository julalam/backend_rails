class Language < ApplicationRecord
  has_many :messages
  has_many :users

  validates :text, presence: true
end
