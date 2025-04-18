# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'profile page without user' do
    get profile_path
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'profile page with user' do
    sign_in users(:user)
    get profile_path
    assert_response :success
  end
end
