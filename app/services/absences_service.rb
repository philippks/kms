class AbsencesService
  def calculate_default_hours(absence)
    if absence.from_date.present? && absence.to_date.present?
      if absence.from_date.monday? && absence.to_date.friday?
        TargetHours.hours_between_for_employee(from: absence.from_date, to: absence.to_date, employee: absence.employee)
      else
        TargetHours.hours_between(from: absence.from_date, to: absence.to_date)
      end
    end
  end
end
