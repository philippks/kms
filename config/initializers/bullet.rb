if Rails.env.test? || Rails.env.development?
  Bullet.add_whitelist type: :unused_eager_loading,
                       class_name: 'Invoices::Expense',
                       association: :efforts

  # whitelisted because in activities::index used for xls or pdf export
  Bullet.add_whitelist type: :unused_eager_loading,
                       class_name: 'Activity',
                       association: :invoice_effort

  # whitelisted because in activities::index used for xls or pdf export
  Bullet.add_whitelist type: :unused_eager_loading,
                       class_name: 'Activity',
                       association: :activity_category
end
