module Invoices
  class Mail < ActiveRecord::Base
    def self.table_name_prefix
      'invoice_'
    end

    has_paper_trail

    belongs_to :employee
    belongs_to :invoice

    validates :body, :from, :to, :employee, :invoice, presence: true

    delegate :sent_at, to: :invoice
  end
end
