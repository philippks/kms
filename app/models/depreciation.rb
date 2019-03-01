class Depreciation < ApplicationRecord
  belongs_to :customer
  belongs_to :employee
  has_many :efforts, dependent: :nullify

  before_save :set_persisted_total_amount

  monetize :persisted_total_amount_cents

  def total_amount
    persisted_total_amount || efforts.collect(&:amount).inject(:+) || Money.new(0)
  end

  def set_persisted_total_amount
    self.persisted_total_amount = total_amount
  end
end
