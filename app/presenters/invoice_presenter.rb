class InvoicePresenter < BasePresenter
  include MoneyRails::ActionViewExtension

  %i[activities_amount expenses_amount efforts_amount vat_amount total_amount].each do |method|
    define_method "humanized_#{method}" do
      humanized_money send(method)
    end
  end

  def title
    super.presence || Invoices::Title.new(self)
  end

  def possible_wir_amount_text
    I18n.t 'invoices.pdfs.new.possible_wir_amount_text',
           amount: humanized_money(possible_wir_amount, no_cents_if_whole: true)
  end

  def confidential_hours
    activities.confidentials.map(&:hours).sum(0)
  end

  def confidential_hourly_rate
    if activities.confidentials.map(&:hourly_rate).uniq.size > 1
      I18n.t 'invoices.pdfs.new.various_hourly_rates_shortcut'
    else
      humanized_money(activities.confidentials.first.hourly_rate, no_cents_if_whole: true)
    end
  end

  def confidential_amount
    humanized_money(activities.confidentials.map(&:amount).sum(0))
  end

  def confidential_supplement?
    confidential? && activities.visible.confidentials.any?
  end
end
