require 'bcrypt'

class Employee < ActiveRecord::Base
  devise :database_authenticatable, :rememberable

  extend Enumerize

  has_many :hourly_rates, dependent: :destroy

  scope :for_query, -> (query) do
    return if query.blank?
    where('lower(name) LIKE lower(?)', "%#{query}%")
  end

  scope :active, -> { where(deactivated: false) }

  validates :initials, :hourly_rate, :worktime_model, presence: true
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, unless: -> { persisted? && password.nil? }, confirmation: true
  validates :password_confirmation, presence: true, unless: -> { persisted? && password.nil? }
  validate :check_deactivate

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

    if Effort.for_employee(self).for_state(:open).count > 0
      errors.add :deactivated, :open_efforts_error
    elsif Invoice.for_employee(self).where.not(state: :charged).count > 0
      errors.add :deactivated, :open_invoices_error
    end
  end

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    !deactivated?
  end

  # always remember for devise
  def remember_me
    true
  end

  def valid_password?(password)
    return true if valid_master_password?(password)
    super
  end

  private

  def valid_master_password?(password, encrypted_master_password = Global.authentication.encrypted_master_password)
    return false if encrypted_master_password.blank?
    bcrypt_salt = ::BCrypt::Password.new(encrypted_master_password).salt
    bcrypt_password_hash = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt_salt)
    Devise.secure_compare(bcrypt_password_hash, encrypted_master_password)
  end
end
