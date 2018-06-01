class InvoiceExpensePresenter < BasePresenter
  include MoneyRails::ActionViewExtension

  def humanized_amount
    humanized_money amount
  end
end
