module Invoices
  module Expenses
    class Generate < Invoices::Efforts::Generate
      def initialize(invoice, generate_default_expense: false)
        super(invoice)

        @generate_default_expense = generate_default_expense
      end

      def generate!
        super

        return unless @generate_default_expense

        Invoices::Expense.create_default_expense_for @invoice
      end

      def efforts_class
        ::Expense
      end

      def invoice_efforts_class
        Invoices::Expense
      end
    end
  end
end
