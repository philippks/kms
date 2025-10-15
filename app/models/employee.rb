require 'bcrypt'

class Employee < ApplicationRecord
  devise :database_authenticatable, :rememberable

  extend Enumerize

  has_many :hourly_rates, dependent: :destroy

  scope :for_query, lambda { |query|
    return if query.blank?

    where('lower(name) LIKE lower(?)', "%#{query}%")
  }

  scope :active, -> { where(deactivated: false) }

  validates :initials, :hourly_rate, :worktime_model, presence: true
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, unless: -> { persisted? && password.nil? }, confirmation: true
  validates :password_confirmation, presence: true, unless: -> { persisted? && password.nil? }
  validate :check_deactivate
  validates :workload, presence: true,
                       numericality: { greater_than: 0, less_than_or_equal_to: 100 },
                       unless: lambda {
                         worktime_model.debit_is_actual?
                       }

  enumerize :worktime_model, in: { target_hours: 0, debit_is_actual: 1 }, default: :target_hours

  monetize :hourly_rate_cents

  def activity_hours_today
    Activity.for_employee(self).where(date: Date.current).sum(:hours)
  end

  def target_hours_reached_in_percent
    activity_hours = activity_hours_today
    target_hours = TargetHours.hours_between(from: Date.current, to: Date.current)

    activity_hours >= target_hours ? 100 : (100.0 / target_hours * activity_hours)
  end

  def check_deactivate
    return unless deactivated

    if Effort.for_employee(self).for_state(:open).count.positive?
      errors.add :deactivated, :open_efforts_error
    elsif Invoice.for_employee(self).where.not(state: :charged).count.positive?
      errors.add :deactivated, :open_invoices_error
    end
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    !deactivated?
  end

  # always remember for devise
  def remember_me
    true
  end

  def workload_in_percent
    workload * 0.01
  end
end
