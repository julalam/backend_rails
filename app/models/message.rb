class Message < ApplicationRecord
  has_one :language
  has_one :from, :class_name => "User"
  has_one :to, :class_name => "User"

  validates :text, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :language, presence: true
end
