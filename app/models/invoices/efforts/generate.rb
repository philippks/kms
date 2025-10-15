module Invoices
  module Efforts
    class Generate
      attr_accessor :invoice

      def initialize(invoice)
        @invoice = invoice
      end

      def generate!
        efforts_grouped_by_text.each_value do |efforts|
          invoice_efforts_class.create! invoice: @invoice,
                                        text: efforts.first.text,
                                        effort_ids: efforts.map(&:id)
        end
      end

      private

      def efforts_grouped_by_text
        chargeable_efforts.group_by do |expense|
          expense.text.downcase.delete(' ')
        end
      end

      def chargeable_efforts
        efforts_class.where(customer: @invoice.customer, invoice_effort_id: nil).order(date: :asc)
      end
    end
  end
end
