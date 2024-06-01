if Global.sentry.dsn.present?
  Sentry.init do |config|
    config.dsn = Global.sentry.dsn
  end
end
