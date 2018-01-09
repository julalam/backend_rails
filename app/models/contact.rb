class Contact < ApplicationRecord
  # belongs_to :from_user, 
  validates :from, presence: true
  validates :to, presence: true
end
