class User < ApplicationRecord

  validates :username, presence: true, uniqueness: true
  validates :language, presence: true
end
