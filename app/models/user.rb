class User < ApplicationRecord
  belongs_to :language

  has_many :from_contacts, :class_name => 'Contact', :foreign_key => 'from'
  has_many :to_contacts, :class_name => 'Contact', :foreign_key => 'to'

  has_many :from_messages, :class_name => 'Message', :foreign_key => 'from'
  has_many :to_messages, :class_name => 'Message', :foreign_key => 'to'

  has_attached_file :avatar,
  styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  },
  default_url: 'https://s3-us-west-2.amazonaws.com/speakeasy-avatars/default-user.png'

  validates :username, presence: true, uniqueness: true, length: { in: 3..15 }
  validates :language, presence: true
  validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, presence: true, length: { in: 6..10 }

  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/

  after_commit { OnlineStateRelayJob.perform_later(self) }
end
