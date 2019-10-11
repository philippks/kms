class Effort < ActiveRecord::Base
  extend Enumerize

  has_paper_trail

  belongs_to :employee
  belongs_to :customer
  belongs_to :invoice_effort, class_name: '::Invoices::Effort', optional: true

  validates :employee, :customer_id, :text, :date, presence: true

  enumerize :state, in: { open: 0, charged: 1, not_chargeable: 2 }, scope: true

  before_validation :set_state

  scope :before, -> (date) { where('date <= ?', date.to_date) }
  scope :after, -> (date) { where('date >= ?', date.to_date) }
  scope :for_customer, -> (customer_id) { where(customer_id: customer_id) }
  scope :for_employee, -> (employee_id) { where(employee_id: employee_id) }
  scope :for_customer_group, -> (customer_group_id) do
    includes(:customer).where(customers: { customer_group_id: customer_group_id })
  end
  scope :for_state, -> (state) { with_state(state) }
  scope :without_invoice, -> { where(invoice_effort_id: nil) }

  delegate :invoice, :invoice_id, to: :invoice_effort, allow_nil: true

  def self.between(from:, to:)
    where('date >= ? AND date <= ?', from, to)
  end

  def self.open_amount_for(customer)
    Money.new for_customer(customer).without_invoice.sum(:amount_cents)
  end

  def text=(value)
    super(value.try(:strip))
  end

  private

  def set_state
    self.state = if customer&.customer_group&.not_chargeable?
                   :not_chargeable
                 elsif invoice_effort.present?
                   :charged
                 else
                   :open
                 end
  end
end
