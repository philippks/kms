Airbrake.configure do |config|
  config.host = Global.airbrake.host
  config.project_id = 1 # required, but any positive integer works
  config.project_key = Global.airbrake.project_key || 'dummy'
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
  config.root_directory = Rails.root
end

unless Global.airbrake.project_key && Global.airbrake.host
  Airbrake.add_filter(&:ignore!)
end
