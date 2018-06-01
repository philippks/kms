module Activities
  class Report
    class InvoicesCube
      KEYS = [:charged].freeze

      def initialize(invoices)
        @invoices = invoices
      end

      def value_for(*keys)
        check_key! keys.last

        values.dig(*keys) || Money.from_amount(0)
      end

      private

      def check_key!(key)
        raise "invalid data key: #{key}" if KEYS.exclude? key
      end

      def values
        @values ||= @invoices.inject({}) do |values, invoice|
          values.deep_merge!(values_hash_for(invoice)) do |_key, old_value, new_value|
            (old_value || 0) + (new_value || 0)
          end
        end
      end

      # Returns following hash for the given invoice
      # {
      #   total: {
      #     values...
      #   },
      #
      #   nil => {
      #     customer_1: {
      #       values...
      #     }
      #
      #     values...
      #   }
      #
      #   customer_group_1 => {
      #     ...
      #   }
      # }
      def values_hash_for(invoice)
        values = {
          charged: invoice.efforts_amount,
        }

        {
          total: values,
          invoice.customer.customer_group => {
            invoice.customer => values,
          }.merge(values),
        }
      end
    end
  end
end
