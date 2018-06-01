class Expense < Effort
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  monetize :amount_cents
end
