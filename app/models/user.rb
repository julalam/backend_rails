class User < ApplicationRecord
  has_many :from_contacts, :class_name => 'Contact', :foreign_key => 'from'
  has_many :to_contacts, :class_name => 'Contact', :foreign_key => 'to'

  validates :username, presence: true, uniqueness: true
  validates :language, presence: true
end
