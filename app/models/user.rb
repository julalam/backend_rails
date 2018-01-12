class User < ApplicationRecord
  has_many :from_contacts, :class_name => 'Contact', :foreign_key => 'from'
  has_many :to_contacts, :class_name => 'Contact', :foreign_key => 'to'

  validates :username, presence: true, uniqueness: true, length: { maximum: 15 }
  validates :language, presence: true
  # validates :email, presence: true, format: { with: /^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i }
  validates :password, presence: true, length: {in: 6..10 }
end
