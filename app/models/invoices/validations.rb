module Invoices
  module Validations
    def self.included(invoice)
      invoice.validates :employee, presence: true
      invoice.validates :customer, presence: true
      invoice.validate  :customer_attributes_validation
      invoice.validates :vat_rate, presence: true
      invoice.validates :date, presence: true
      invoice.validate :validate_format
    end

    private

    def customer_attributes_validation
      if customer
        customer.valid?

        if confidential? && customer.confidential_title.blank?
          errors.add(:confidential, :confidential_title_necessary)
        end
      end
    end

    def validate_format
      if format == :detailed
        if activities_amount_manually.present?
          errors.add(:format, :activities_amount_set_manually)
        end

        if activities.select { |activity| !activity.visible? }.any?
          errors.add(:format, :hidden_activities)
        end

        if (activities.map(&:hourly_rate).count(nil) > 0)
          errors.add(:format, :conflicting_activities)
        end
      end
    end
  end
end
