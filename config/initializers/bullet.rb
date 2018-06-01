if Rails.env.test? || Rails.env.development?
  Bullet.add_whitelist type: :unused_eager_loading,
                       class_name: 'Invoices::Expense',
                       association: :efforts
end
