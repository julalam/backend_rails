class Language < ApplicationRecord
  validates :text, presence: true
end
