class InvoicePresenter < BasePresenter
  include MoneyRails::ActionViewExtension

  %i(activities_amount expenses_amount efforts_amount vat_amount total_amount).each do |method|
    define_method "humanized_#{method}" do
      humanized_money send(method)
    end
  end

  def possible_wir_amount_text
    I18n.t 'invoices.pdf.possible_wir_amount_text', amount: humanized_money(possible_wir_amount, no_cents_if_whole: true)
  end

  def date
    I18n.l(super, format: :long)
  end

  def confidential_hours
    activities.confidentials.sum(&:hours)
  end

  def confidential_hourly_rate
    if activities.confidentials.map(&:hourly_rate).uniq.size > 1
      I18n.t 'invoices.pdf.various_hourly_rates_shortcut'
    else
      humanized_money(activities.confidentials.first.hourly_rate, no_cents_if_whole: true)
    end
  end

  def confidential_amount
    humanized_money(activities.confidentials.sum(&:amount))
  end
end
