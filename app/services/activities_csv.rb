class ActivitiesCsv
  COLUMNS = {
    id: :id.to_proc,
    employee: ->(activity) { activity.employee.name },
    customer: ->(activity) { activity.customer.name },
    date: ->(activity) { I18n.l(activity.date) },
    hours: :hours.to_proc,
    hourly_rate: ->(activity) { humanized_money(activity.hourly_rate) },
    amount: ->(activity) { humanized_money(activity.amount) },
    text: :text.to_proc,
    note: :note.to_proc,
    state: lambda { |activity|
             I18n.t("enumerize.defaults.state.#{activity.state}")
           },
    activity_category: ->(activity) { activity.activity_category&.name },

  }.freeze

  def to_csv(activities)
    CSV.generate do |csv|
      csv << COLUMNS.keys.map(&Activity.method(:human_attribute_name))
      activities.each do |activity|
        csv << COLUMNS.values.map { |column| column.call(activity) }
      end
    end
  end

  def self.humanized_money(amount)
    ActionController::Base.helpers.humanized_money(amount)
  end
end
