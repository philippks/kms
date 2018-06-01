class AbsencePresenter < BasePresenter
  def date
    return I18n.l(from_date) if one_day_absence?
    "#{I18n.l(from_date)} - #{I18n.l(to_date)}"
  end
end
