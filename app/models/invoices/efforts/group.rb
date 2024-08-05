module Invoices
  module Efforts
    class Group
      def initialize(invoice, effort_ids)
        @invoice = invoice
        @effort_ids = effort_ids
      end

      def group_efforts!
        return if efforts.empty?

        new_invoice_effort.save!
        efforts.destroy_all
      end

      private

      def new_invoice_effort
        efforts_class.new invoice: @invoice,
                          text:,
                          position:,
                          confidential:,
                          efforts: assigned_efforts
      end

      def text
        efforts.first.text
      end

      def position
        efforts.first.position
      end

      def confidential
        efforts.first.confidential
      end

      def assigned_efforts
        efforts.map(&:efforts).flatten
      end

      def efforts
        @efforts ||= Invoices::Effort.where(id: @effort_ids)
                                     .includes(efforts: :employee)
      end

      def efforts_class
        efforts.first.class
      end
    end
  end
end
