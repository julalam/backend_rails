class User < ApplicationRecord
  has_many :from_contacts, :class_name => 'Contact', :foreign_key => 'from'
  has_many :to_contacts, :class_name => 'Contact', :foreign_key => 'to'

  validates :username, presence: true, uniqueness: true, length: { in: 3..15 }
  validates :language, presence: true
  validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, presence: true, length: { in: 6..10 }
end
