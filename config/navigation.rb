SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :activities, Activity.model_name.human(count: 2),
                              activities_path,
                              highlights_on: %r{\A/activities(/(\d+/.*|new|edit|new\?.*)|\?.*|)\z},
                              html: { class: 'sub_nav' } do |sub_nav|
      sub_nav.item :op_list, I18n.t('application.navigation.op_list'), new_op_list_path
    end

    primary.item :expenses, Expense.model_name.human(count: 2), expenses_path, highlights_on: %r{\A/expenses(/.*)?\z}
    primary.item :absences, Absence.model_name.human(count: 2), absences_path, highlights_on: %r{\A/absences(/.*)?\z}
    primary.item :invoices, Invoice.model_name.human(count: 2), invoices_path, highlights_on:  %r{\A/invoices(/.*)?\z}

    primary.item :activities_report,
                 t('application.navigation.activities_report'),
                 new_activities_report_path,
                 highlights_on:  %r{\A/activities/reports(/.*)?\z}
  end
end
