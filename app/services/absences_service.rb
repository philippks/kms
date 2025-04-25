class AbsencesService
  def calculate_default_hours(from_date, to_date, employee)
    return nil if to_date < from_date

    if from_date.monday? && to_date.friday?
      TargetHours.hours_between_for_employee(from: from_date, to: to_date, employee:)
    else
      TargetHours.hours_between(from: from_date, to: to_date)
    end
  end
end
