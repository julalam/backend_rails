class User < ApplicationRecord
  has_many :from, :class_name => 'Contact', :foreign_key => 'from_id'
  has_many :to, :class_name => 'Contact', :foreign_key => 'to_id'

  validates :username, presence: true, uniqueness: true
  validates :language, presence: true
end
