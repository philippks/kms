module Invoices
  class Expense < ::Invoices::Effort
    acts_as_list scope: %i[invoice_id type]

    def amount
      return amount_manually if amount_manually.present?

      actual_amount
    end

    def actual_amount
      efforts.to_a.map(&:amount).sum(0)
    end

    def self.create_default_expense_for(invoice)
      create invoice:,
             text: I18n.t('invoice.default_expense_text'),
             amount_manually: default_amount_for(activities_amount: invoice.activities_amount)
    end

    def self.default_amount_for(activities_amount:)
      five_percent_of_activities_amount = (activities_amount / 20)

      if five_percent_of_activities_amount.zero?
        Money.from_amount 0
      elsif five_percent_of_activities_amount < Money.from_amount(5)
        Money.from_amount 5
      elsif five_percent_of_activities_amount > Money.from_amount(125)
        Money.from_amount 125
      else
        # round to the nearest multiple of 5
        Money.from_amount(5 * (five_percent_of_activities_amount.to_f / 5).round)
      end
    end
  end
end
