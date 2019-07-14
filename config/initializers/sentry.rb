if Global.sentry.dsn.present?
  Raven.configure do |config|
    config.dsn = Global.sentry.dsn
  end
end
