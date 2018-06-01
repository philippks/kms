class Invoice < ActiveRecord::Base
  extend Enumerize
  include AASM
  include Invoices::Validations

  belongs_to :employee
  belongs_to :customer

  accepts_nested_attributes_for :customer, update_only: true

  has_many :activities, -> { reorder(:confidential, :position) },
           class_name: '::Invoices::Activity',
           dependent: :destroy

  has_many :expenses, -> { reorder(:position) },
           class_name: '::Invoices::Expense',
           dependent: :destroy

  has_many :payments, dependent: :destroy, class_name: '::Invoices::Payment'
  has_one :mail, dependent: :destroy, class_name: '::Invoices::Mail'

  enumerize :format, in: { compact: 0, detailed: 1 }, default: :compact
  enumerize :delivery_method, in: { post: 0, email: 1 }, default: :post

  scope :before, ->(date) { where('invoices.date <= ?', date.to_date) }
  scope :after, ->(date) { where('invoices.date >= ?', date.to_date) }
  scope :for_customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :for_employee, ->(employee_id) { where(employee_id: employee_id) }
  scope :for_state, ->(state) { where(state: state) }
  scope :for_customer_group, ->(customer_group_id) do
    includes(:customer).where(customers: { customer_group_id: customer_group_id })
  end

  monetize :activities_amount_manually_cents,
           :possible_wir_amount_cents,
           :persisted_total_amount_cents,
           allow_nil: true

  aasm column: :state, whiny_persistence: true do
    state :open, initial: true
    state :sent
    state :charged

    event :complete do
      transitions from: :incomplete, to: :open, after: :persist_total_amount
    end

    event :deliver do
      transitions from: :open, to: :sent, after: [:persist_total_amount, :persist_pdf, :update_sent_at]
    end

    event :charge do
      transitions from: :sent, to: :charged
    end

    event :reopen do
      transitions from: [:sent, :charged],
                  to: :open,
                  after: [:clear_persisted_total_amount, :remove_persisted_pdf]
    end
  end

  def self.between(from:, to:)
    where('date >= ? AND date <= ?', from, to)
  end

  def efforts_amount
    activities_amount + expenses_amount
  end

  def vat_amount
    Money.new (vat_rate * efforts_amount).round_to_nearest_cash_value
  end

  def total_amount
    persisted_total_amount || efforts_amount + vat_amount
  end

  def open_amount(ignore: nil)
    total_amount - payments.select(&:persisted?).without(ignore).sum(&:amount)
  end

  def payed_amount
    Money.new payments.sum(:amount_cents)
  end

  def activities_amount
    activities_amount_manually || activities.includes(:efforts).collect(&:amount).inject(:+) || Money.new(0)
  end

  def expenses_amount
    expenses.includes(:efforts).collect(&:amount).inject(:+) || Money.new(0)
  end

  def persist_total_amount
    update!(persisted_total_amount: efforts_amount + vat_amount)
  end

  def persist_pdf
    Invoices::PDF.new(self).create_persisted
  end

  def update_sent_at
    update!(sent_at: DateTime.current)
  end

  def clear_persisted_total_amount
    update!(persisted_total_amount: nil)
  end

  def remove_persisted_pdf
    Invoices::PDF.new(self).remove_persisted_pdf
  end
end
