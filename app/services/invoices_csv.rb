class InvoicesCsv
  COLUMNS = {
    id: :id.to_proc,
    employee: ->(invoice) { invoice.employee.name },
    customer: ->(invoice) { invoice.customer.name },
    date: ->(invoice) { I18n.l(invoice.date) },
    amount: ->(invoice) { humanized_money(invoice.total_amount) },
    state: lambda { |invoice|
             I18n.t("activerecord.attributes.invoice.state/#{invoice.state}")
           },

  }.freeze

  def to_csv(invoices)
    CSV.generate do |csv|
      csv << COLUMNS.keys.map(&Invoice.method(:human_attribute_name))
      invoices.each do |invoice|
        csv << COLUMNS.values.map { |column| column.call(invoice) }
      end
    end
  end

  def self.humanized_money(amount)
    ActionController::Base.helpers.humanized_money(amount)
  end
end
