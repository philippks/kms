class CustomerGroup < ApplicationRecord
  validates :name, presence: true

  has_many :customer

  def chargeable?
    !not_chargeable?
  end
end
