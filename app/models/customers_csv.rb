class CustomersCsv
  include ActiveModel::Model

  CSV_ATTRIBUTES = %i[name
                      confidential_title
                      address
                      email_address
                      customer_group_name
                      invoice_hint].freeze

  def initialize(customers)
    @customers = customers
  end

  def csv
    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << CSV_ATTRIBUTES

      @customers.each do |customer|
        csv << CSV_ATTRIBUTES.map do |attribute|
          customer.send(attribute)
        end
      end
    end
  end
end
