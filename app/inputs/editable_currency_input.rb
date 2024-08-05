class EditableCurrencyInput < SimpleForm::Inputs::Base
  include MoneyRails::ActionViewExtension
  def input(_wrapper_options = nil)
    template.content_tag :div,
                         "#{currency_addon} #{editable_label}".html_safe,
                         class: 'input-group currency'
  end

  private

  def currency_addon
    template.content_tag(:span, 'CHF', class: 'input-group-addon')
  end

  def editable_label
    input_html_options[:class] << 'editable'
    template.content_tag(:div, class: 'form-control') do
      template.content_tag(:span, humanized_money(input_html_options[:value]), input_html_options)
    end
  end
end
