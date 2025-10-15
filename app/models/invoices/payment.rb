module Invoices
  class Payment < ApplicationRecord
    def self.table_name_prefix
      'invoice_'
    end

    has_paper_trail

    belongs_to :invoice

    validates :date, :amount, presence: true
    validates :amount, numericality: { greater_than: 0 }
    validate :amount_not_greater_than_open_invoice_amount

    monetize :amount_cents

    attr_accessor :mark_invoice_charged_anyway

    private

    def amount_not_greater_than_open_invoice_amount
      if amount > invoice.open_amount(ignore: self)
        errors.add(:amount, :greater_than_open_invoice_amount)
        return false
      end
      true
    end
  end
end
