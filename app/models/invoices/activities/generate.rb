module Invoices
  module Activities
    class Generate < Invoices::Efforts::Generate
      def efforts_class
        ::Activity
      end

      def invoice_efforts_class
        Invoices::Activity
      end
    end
  end
end
