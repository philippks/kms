require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Options.chrome(args: %w[no-sandbox headless disable-gpu])
  options.add_option('goog:loggingPrefs', { browser: 'ALL' })

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.javascript_driver = :headless_chrome

Capybara.asset_host = 'http://localhost:3000'

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
end

class JavascriptConsoleError < StandardError
  def initialize(console_messages) # rubocop:disable Lint/MissingSuper
    @console_messages = console_messages
  end

  def message
    "Heads up! There were JS console errors:\n#{@console_messages}"
  end
end

IGNORED_WARNINGS = [
  'Warning: Load test font never loaded.',
  'XMLHttpRequest.responseType "moz-chunked-arraybuffer" is not supported.',
  "Consider using 'dppx' units instead of 'dpi', as in CSS 'dpi' means dots-per-CSS-inch, not dots-per-physical-inch, so does not correspond to the actual 'dpi' of a screen. In media query expression: only screen and (-webkit-min-device-pixel-ratio: 1.5), only screen and (min-resolution: 144dpi), only screen and (min-resolution: 1.5dppx)", # rubocop:disable Layout/LineLength
  'TypeError: fontRes.getRaw is not a function',
].freeze

RSpec.configure do |config|
  config.after(:each, js: true) do
    console_messages = page.driver.browser.logs.get(:browser)
    console_messages.delete_if do |message|
      IGNORED_WARNINGS.any? { |ignored_warning| message.message.include? ignored_warning }
    end
    raise JavascriptConsoleError, console_messages if console_messages.any?
  end
end
