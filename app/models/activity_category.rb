class ActivityCategory < ApplicationRecord
  has_many :text_templates, dependent: :destroy

  validates :name, presence: true
end
