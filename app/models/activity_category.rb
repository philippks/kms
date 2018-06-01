class ActivityCategory < ActiveRecord::Base
  has_many :text_templates, dependent: :destroy

  validates :name, presence: true
end
