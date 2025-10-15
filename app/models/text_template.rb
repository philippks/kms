class TextTemplate < ApplicationRecord
  belongs_to :activity_category

  validates :text, presence: true
end
