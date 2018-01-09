class Contact < ApplicationRecord
  belongs_to :from, :class_name => 'User', :foreign_key => 'from_id'
  belongs_to :to, :class_name => 'User', :foreign_key => 'to_id'

  validates :from, presence: true
  validates :to, presence: true
end
