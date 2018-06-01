class PercentInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.content_tag :div,
                         "#{text_field} #{percent_addon}".html_safe,
                         class: 'input-group percent'
  end

  private

  def percent_addon
    template.content_tag(:span, '%', class: 'input-group-addon')
  end

  def text_field
    input_html_options[:class] << 'form-control'

    @builder.text_field(attribute_name, input_html_options)
  end

  def input_html_options
    super.reverse_merge(value: object.send(attribute_name) * 100)
  end
end
