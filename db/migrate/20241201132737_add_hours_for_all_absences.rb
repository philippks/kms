class AddHoursForAllAbsences < ActiveRecord::Migration[7.1]
  def change
    Absence.where(hours: nil).each do |absence|
      absence.update! hours: TargetHours.hours_between(
        from: absence.from_date,
        to:  absence.to_date
      )
    end
  end
end
