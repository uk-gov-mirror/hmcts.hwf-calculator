require 'capybara-screenshot/rspec'
require_relative 'test_common'
module Calculator
  module Test
    module FullScreenshot
      def self.with_resizing
        changed = false
        orig_size = Capybara.current_session.current_window.size
        begin
          width  = Capybara.page.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
          height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
          Capybara.current_session.current_window.resize_to(width + 100, height + 100)
          changed = true
          yield
        ensure
          Capybara.current_session.current_window.resize_to(*orig_size) if changed
        end
      end
    end
  end
end
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  ::Calculator::Test::FullScreenshot.with_resizing do
    driver.browser.save_screenshot(path)
  end
end
Capybara::Screenshot.register_driver(:chromedriver) do |driver, path|
  ::Calculator::Test::FullScreenshot.with_resizing do
    driver.browser.save_screenshot(path)
  end
end
Capybara::Screenshot.register_driver(:firefoxdriver) do |driver, path|
  ::Calculator::Test::FullScreenshot.with_resizing do
    driver.browser.save_screenshot(path)
  end
end
Capybara::Screenshot.register_driver(:saucelabs) do |driver, path|
  driver.browser.save_screenshot(path)
end

Calculator::Test::Saucelabs.browsers.keys.each do |browser|
  Capybara::Screenshot.register_driver(browser) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end
