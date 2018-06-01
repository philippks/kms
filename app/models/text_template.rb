class TextTemplate < ActiveRecord::Base
  belongs_to :activity_category

  validates :text, presence: true
end
