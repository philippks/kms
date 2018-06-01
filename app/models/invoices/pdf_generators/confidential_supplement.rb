module Invoices
  module PDFGenerators
    class ConfidentialSupplement < PDFGenerator
      attr_accessor :invoice

      def initialize(invoice)
        @invoice = invoice
      end

      def generate_odt
        ODFReport::Report.new(template_path) do |odf_report|
          odf_report.add_field :customer, invoice.customer.name
          odf_report.add_field :title, invoice.title.presence || Title.new(invoice).to_s

          odf_report.add_section :activity_row, activities_presenters do |section|
            section.add_field(:text, :text)
            section.add_field(:hours, :hours)
            section.add_field(:rate, :hourly_rate_as_int)
            section.add_field(:amount, :humanized_amount)
          end

          odf_report.add_field :total, invoice_presenter.confidential_amount

          odf_report.add_field :date, invoice_presenter.date
        end.generate odt.path
      end

      private

      def file_name
        "invoice_#{invoice.date.to_s.underscore}_confidential_supplement"
      end

      def template_path
        "#{Rails.root}/config/templates/invoice_#{invoice.format}_confidential_supplement.odt"
      end

      def invoice_presenter
        @invoice_presenter ||= InvoicePresenter.new @invoice
      end

      def activities_presenters
        invoice.activities.confidentials.map { |activity| InvoiceActivityPresenter.new activity }
      end
    end
  end
end
