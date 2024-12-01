class Absence < ActiveRecord::Base
  extend Enumerize

  belongs_to :employee

  validates :employee, :reason, :from_date, :to_date, presence: true
  validates :hours, presence: true
  validate :to_after_from

  enumerize :reason, in: { holidays: 0, doctor: 1, funeral: 2, disease: 3,
                           personal: 4, death_family: 5, military: 6 }

  scope :before, ->(date) { where('from_date <= ?', date.to_date) }
  scope :after, ->(date) { where('from_date >= ?', date.to_date) }
  scope :for_employee, ->(employee_id) { where(employee_id:) }
  scope :for_reason, ->(reason) { where(reason: Absence.reason.find_value(reason).value) }

  def absent_target_hours(from: from_date, to: to_date)
    return hours if one_day_absence?
    # we can return the full hours if the requested range covers the full absence
    if from <= from_date && to >= to_date
      return hours
    end

    # if the requested range does not cover the full range of the absence, it's getting compicated...
    start_date = [from_date, from].max
    end_date = [to, to_date].min

    # calculate the absent target hours for the full absence
    absent_target_hours_of_full_absence = TargetHours.hours_between(from: from_date, to: to_date)

    # and the absent target hours in the requested range
    absent_target_hours_within_requested_range = TargetHours.hours_between(from: start_date, to: end_date)

    # calculate a hours per target hours ratio
    absent_hours_per_target_hours = absent_target_hours_of_full_absence / hours

    # and multiply this by the absent target hours with in the range
    absent_hours_per_target_hours * absent_target_hours_within_requested_range
  end

  def to_after_from
    errors.add(:to_date, :to_not_after_from) if to_date.to_date < from_date.to_date
  end

  def one_day_absence?
    to_date == from_date
  end

  def self.between(from:, to:)
    where('(from_date >= :from AND from_date <= :to) OR (to_date >= :from AND to_date <= :to)', from:, to:)
  end

  def per_date_hash
    (from_date..to_date).inject({}) do |hash, date|
      hash.merge(date => [self])
    end
  end
end
