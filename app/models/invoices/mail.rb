module Invoices
  class Mail < ApplicationRecord
    def self.table_name_prefix
      'invoice_'
    end

    has_paper_trail

    belongs_to :employee
    belongs_to :invoice

    validates :body, :from, :to, presence: true

    delegate :sent_at, to: :invoice
  end
end
