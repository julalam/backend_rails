class User < ApplicationRecord
  # has_many :messages
  # has_one :language

  validates :username, presence: true, uniqueness: true
  validates :language, presence: true
end
