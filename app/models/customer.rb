class Customer < ActiveRecord::Base
  extend Enumerize

  belongs_to :customer_group, optional: true
  has_many :efforts

  scope :for_customer, ->(customer_id) { where(id: customer_id) }
  scope :for_customer_group, lambda { |customer_group_id|
    where(customer_group_id: customer_group_id)
  }
  scope :for_query, lambda { |query|
    where('lower(name) LIKE lower(?)', "%#{query}%")
  }
  scope :active, -> { where(deactivated: false) }

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, if: -> { !customer_group&.not_chargeable? }
  validates :email_address, format: { with: /@/, allow_blank: true }
  validates :email_address, presence: true, if: -> { invoice_delivery == :email }

  delegate :name, to: :customer_group, allow_nil: true, prefix: true

  enumerize :invoice_delivery, in: { post: 0, email: 1 }, default: :post

  def name=(value)
    super(value.try(:strip))
  end
end
