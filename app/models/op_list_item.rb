class OpListItem
  attr_reader :customer, :activities

  def initialize(customer, activities)
    @customer = customer
    @activities = activities
  end

  def self.build_for(employee_id:, until_date: Date.current)
    @op_list_items = build_for_date(until_date: until_date)

    unless employee_id.nil?
      @op_list_items.reject! do |op_list_item|
        op_list_item.activities.map(&:employee_id).exclude? employee_id
      end
    end

    @op_list_items
  end

  def self.build_for_date(until_date:)
    Activity.for_state(:open)
            .where('date <= ?', until_date)
            .where('amount_cents > 0')
            .includes(:customer, :employee)
            .group_by(&:customer)
            .map { |group| new(group[0], group[1]) }
  end

  def range_string
    if dates.one?
      I18n.l(dates.first, format: :vague)
    else
      I18n.t('op_lists.table.between', from: I18n.l(dates.first, format: :vague),
                                       to: I18n.l(dates.last, format: :vague))
    end
  end

  def employees
    activities.map(&:employee).sort_by(&:name).uniq
  end

  def amount
    Money.new @activities.sum(&:amount_cents)
  end

  def overdue?
    overdue_date = Date.current - Global.op_list.overdue_days.days
    min_amount = Money.from_amount Global.op_list.overdue_min_amount
    latest_date = activities.map(&:date).max
    latest_date <= overdue_date && amount >= min_amount
  end

  private

  def dates
    @dates ||= activities.map(&:date).map(&:beginning_of_month).uniq.sort
  end
end
