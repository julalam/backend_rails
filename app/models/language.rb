class Language < ApplicationRecord
  has_many :users
  has_many :messages

  validates :name, presence: true, uniqueness: true
  validates :native_name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
