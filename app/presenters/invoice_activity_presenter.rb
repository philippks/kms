class InvoiceActivityPresenter < BasePresenter
  include MoneyRails::ActionViewExtension

  def humanized_amount
    humanized_money amount
  end

  def hourly_rate_as_int
    hourly_rate.to_i
  end
end
