# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include TestHelpers

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400] do |driver|
    driver.add_argument('--no-sandbox')
    driver.add_argument('--disable-gpu')
  end
end
