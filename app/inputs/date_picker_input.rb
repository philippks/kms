class DatePickerInput < SimpleForm::Inputs::StringInput
  FORMAT = I18n.t('date.formats.default', default: '%d/%m/%Y').freeze

  def input(wrapper_options)
    input_html_options[:value] ||= localized_value
    input_html_options[:type] = 'text'

    template.content_tag :div, class: 'input-group date' do
      input = super(wrapper_options)

      input += template.content_tag :span, class: 'input-group-addon' do
        template.content_tag :i, '', class: 'glyphicon glyphicon-calendar'
      end
      input
    end
  end

  def localized_value
    value = object.send(attribute_name)
    I18n.localize(safe_parse_date(value.to_s), format: FORMAT) if value.present?
  end

  def safe_parse_date(value)
    # handle '11.11.17' as '11.11.2017'
    if value =~ /^\d{1,2}\.\d{1,2}\.\d{2}$/
      Date.strptime(value, '%d.%m.%y')
    else
      Date.parse(value)
    end
  end

  def input_html_classes
    super.push ''
  end
end
