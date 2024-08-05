class CurrencyInput < SimpleForm::Inputs::Base
  include MoneyRails::ActionViewExtension

  def input(_wrapper_options = nil)
    template.content_tag :div,
                         "#{currency_addon} #{text_field}".html_safe,
                         class: 'input-group currency'
  end

  private

  def currency_addon
    template.content_tag(:span, Money.default_currency.symbol, class: 'input-group-addon')
  end

  def text_field
    input_html_options[:class] << 'form-control'

    @builder.text_field(attribute_name, input_html_options)
  end

  def input_html_options
    super.reverse_merge(value: humanized_money(object.send(attribute_name)))
  end
end
