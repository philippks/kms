class Activity < Effort
  belongs_to :activity_category, optional: true

  validates :hours, :hourly_rate, presence: true
  validates :hours, numericality: { greater_than_or_equal: 0 }

  scope :for_activity_category, lambda { |activity_category_id|
    where(activity_category_id:)
  }

  monetize :hourly_rate_cents, :amount_cents

  before_save :update_amount

  def amount
    self[:amount] if persisted?
    calculated_amount
  end

  def update_amount
    self.amount = calculated_amount
  end

  private

  def calculated_amount
    if state.not_chargeable?
      0
    else
      hours * hourly_rate
    end
  end
end
