module Invoices
  class Effort < ActiveRecord::Base
    def self.table_name_prefix
      'invoice_'
    end

    belongs_to :invoice
    has_many :efforts, foreign_key: :invoice_effort_id,
                       dependent: :nullify,
                       inverse_of: :invoice_effort,
                       class_name: '::Effort'

    before_destroy :nullify_efforts, prepend: true

    validates :invoice, presence: true

    default_scope { order(:position) }
    scope :visible, -> { where(visible: true) }
    scope :for_customer, lambda { |customer_id|
      includes(:invoice).where(invoices: { customer_id: })
    }

    monetize :amount_manually_cents, allow_nil: true

    # callback necessary since save callbacks of efforts are not executed
    # when destroying an invoice effort. Therefore manually nullify efforts
    # can be removed with https://github.com/rails/rails/pull/22520
    def nullify_efforts
      efforts.each do |effort|
        effort.update(invoice_effort: nil) if effort.invoice_effort == self
      end
    end

    def assignable_efforts
      ::Effort.where(type: self.class.name.demodulize,
                     customer: invoice.customer,
                     invoice_effort_id: [nil, id])
              .includes(:employee, :customer)
    end

    def effort_notes
      efforts.pluck(:note).reject(&:empty?).uniq
    end
  end
end
