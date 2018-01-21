class Message < ApplicationRecord
  has_one :language

  belongs_to :from_user, :class_name => 'User', :foreign_key => 'from'
  belongs_to :to_user, :class_name => 'User', :foreign_key => 'to'

  validates :text, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :language, presence: true

  after_commit { MessageRelayJob.perform_later(self) }
end
