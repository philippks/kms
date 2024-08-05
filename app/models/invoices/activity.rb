module Invoices
  class Activity < ::Invoices::Effort
    acts_as_list scope: %i[invoice_id type confidential]

    validates :hourly_rate_manually_cents, numericality: true, allow_nil: true

    monetize :hourly_rate_manually_cents, allow_nil: true

    scope :visible, -> { where(visible: true) }
    scope :confidentials, -> { where(confidential: true) }
    scope :non_confidentials, -> { where(confidential: false) }

    def amount
      return amount_manually if amount_manually.present?
      return hours * hourly_rate if hours && hourly_rate

      actual_amount
    end

    def hourly_rate
      return hourly_rate_manually if hourly_rate_manually.present?
      return 0 if efforts.empty?
      return nil if uniq_efforts_hourly_rates.count != 1

      uniq_efforts_hourly_rates.first || 0
    end

    def hours
      hours_manually ||
        efforts.map(&:hours).sum(0).round(4) ||
        0
    end

    def actual_amount
      efforts.to_a.map(&:amount).sum(0)
    end

    private

    def uniq_efforts_hourly_rates
      @uniq_efforts_hourly_rates ||= efforts.pluck(:hourly_rate_cents).uniq.map do |hourly_rate_cents|
        Money.new hourly_rate_cents
      end
    end
  end
end
