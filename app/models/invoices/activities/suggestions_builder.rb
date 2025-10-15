module Invoices
  module Activities
    class SuggestionsBuilder
      SUGGESTIONS_SIZE_LIMIT = 10

      def initialize(query:, invoice_activity_id:)
        @query = query
        @invoice_activity_id = invoice_activity_id
      end

      def build
        suggestions = {}
        suggestions[:assigned_to_invoice_activity] = suggestions_assigned_to_invoice_activity
        suggestions[:previous_invoice_activites] = suggestions_for_previous_invoice_activities
        suggestions
      end

      private

      def suggestions_assigned_to_invoice_activity
        invoice_activity.efforts
                        .first(SUGGESTIONS_SIZE_LIMIT)
                        .pluck(:text)
                        .uniq
      end

      def suggestions_for_previous_invoice_activities
        Invoices::Activity.unscoped
                          .where.not(invoice_id: invoice_activity.invoice_id)
                          .where.not(text: '')
                          .where('lower(text) LIKE lower(?)', "%#{search_query}%")
                          .where(invoices: { customer_id: invoice_activity.invoice.customer_id })
                          .joins(:invoice)
                          .select('text, max(invoice_efforts.id), max(invoices.date) AS date')
                          .order('date DESC')
                          .limit(SUGGESTIONS_SIZE_LIMIT)
                          .group(:text)
                          .map(&:text)
      end

      def invoice_activity
        @invoice_activity ||= Invoices::Activity.find @invoice_activity_id
      end

      def search_query
        invoice_activity.text == @query ? '' : @query
      end

      def text_templates_for(activity_category)
        activity_category.text_templates
                         .select { |text_template| text_template.text.include?(search_query) }
                         .map(&:text)
      end
    end
  end
end
