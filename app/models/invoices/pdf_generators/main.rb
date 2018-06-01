module Invoices
  module PDFGenerators
    class Main < PDFGenerator
      attr_accessor :invoice

      def initialize(invoice)
        @invoice = invoice
      end

      def generate_odt
        ODFReport::Report.new(template_path) do |odf_report|
          odf_report.add_field :confidential_title, invoice.customer.confidential_title
          odf_report.add_field :address, invoice.customer.address
          odf_report.add_field :date, invoice_presenter.date
          odf_report.add_field :created_by_initials, invoice_presenter.created_by_initials
          odf_report.add_field :title, invoice.title.presence || Title.new(invoice).to_s
          odf_report.add_field :vat_rate, invoice.vat_rate * 100 # 0.08 * 100 = 8.0 %
          odf_report.add_field :vat_number, Global.invoices.vat_number
          odf_report.add_field :iban, Global.invoices.iban
          odf_report.add_field :swift, Global.invoices.swift

          odf_report.remove_section :swift unless invoice.display_swift?
          odf_report.remove_section :confidential unless invoice.confidential?

          odf_report.add_section :activity_row, activities_presenters do |section|
            section.add_field(:text, :text)
            section.add_field(:hours, :hours)
            section.add_field(:rate, :hourly_rate_as_int)
            section.add_field(:amount, :humanized_amount)
          end

          odf_report.add_section :expense_row, expenses_presenters do |section|
            section.add_field(:text, :text)
            section.add_field(:amount, :humanized_amount)
          end

          if show_confidential_activities_placeholder?
            odf_report.add_field :confidential_hours, invoice_presenter.confidential_hours
            odf_report.add_field :confidential_rate, invoice_presenter.confidential_hourly_rate
            odf_report.add_field :confidential_amount, invoice_presenter.confidential_amount
          else
            odf_report.remove_section :confidential_activities_placeholder
          end

          odf_report.add_field :activities_amount, invoice_presenter.humanized_activities_amount
          odf_report.add_field :expenses_amount, invoice_presenter.humanized_expenses_amount
          odf_report.add_field :sub_total, invoice_presenter.humanized_efforts_amount
          odf_report.add_field :vat_amount, invoice_presenter.humanized_vat_amount
          odf_report.add_field :total, invoice_presenter.humanized_total_amount

          if invoice_presenter.possible_wir_amount > 0
            odf_report.add_field :possible_wir_amount, invoice_presenter.possible_wir_amount_text
          else
            odf_report.add_field :possible_wir_amount, ''
          end
        end.generate odt.path
      end

      private

      def activities_presenters
        relevant_activities.map { |activity| InvoiceActivityPresenter.new activity }
      end

      def expenses_presenters
        relevant_expenses.map { |expense| InvoiceExpensePresenter.new expense }
      end

      def relevant_activities
        invoice.activities.visible - invoice.activities.confidentials
      end

      def relevant_expenses
        invoice.expenses.visible
      end

      def file_name
        "invoice_#{invoice.date.to_s.underscore}"
      end

      def template_path
        "#{Rails.root}/config/templates/invoice_#{invoice.format}.odt"
      end

      def invoice_presenter
        @invoice_presenter ||= InvoicePresenter.new @invoice
      end

      def show_confidential_activities_placeholder?
        invoice.confidential? &&
          invoice.format.detailed? &&
          invoice.activities.confidentials.any?
      end
    end
  end
end
