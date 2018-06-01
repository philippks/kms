SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |bottom|
    bottom.item :preferences, t('application.navigation.preferences'),
                              employee_hourly_rates_path(current_employee),
                              html: { class: 'sub_nav preferences' } do |sub_nav|
      sub_nav.item :hourly_rates, HourlyRate.model_name.human(count: 2), employee_hourly_rates_path(current_employee), highlights_on:  %r{\A/employees/\d*/hourly_rates(/.*)?\z}
      sub_nav.item :customers, Customer.model_name.human(count: 2), customers_path, highlights_on:  %r{\A/customers(/.*|\?.*)?\z}
      sub_nav.item :customer_groups, CustomerGroup.model_name.human(count: 2), customer_groups_path, highlights_on:  %r{\A/customer_groups(/.*)?\z}
      sub_nav.item :activity_categories, ActivityCategory.model_name.human(count: 2), activity_categories_path, highlights_on:  %r{\A/activity_categories(/.*)?\z}
      sub_nav.item :employees, Employee.model_name.human(count: 2), employees_path, highlights_on:  %r{\A\/employees((\?.*)|(\/\d*\/(edit|new)))?\z}
      sub_nav.item :target_hours, TargetHours.model_name.human(count: 2), target_hours_path, highlights_on:  %r{\A/target_hours(/.*)?\z}
    end
  end
end
