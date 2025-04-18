# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest

  test 'admin page (user.admin == false)' do
    sign_in users(:user)
    get admin_root_path
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'admin page (user.admin == true)' do
    sign_in users(:admin)
    get admin_root_path
    assert_response :success
  end

  test 'admin index page' do
    sign_in users(:admin)
    get admin_bulletins_path
    assert_response :success
  end

  test 'bulletin publish' do
    sign_in users(:admin)

    bulletins(:bulletin_with_image).to_moderate!
    patch publish_admin_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    assert_response :redirect
    assert_equal 'published', bulletins(:bulletin_with_image).reload.state
  end

  test 'bulletin archive' do
    sign_in users(:admin)

    bulletins(:bulletin_with_image).to_moderate!
    bulletins(:bulletin_with_image).publish!

    patch archive_admin_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    assert_response :redirect
    assert_equal 'archived', bulletins(:bulletin_with_image).reload.state
  end

  test 'bulletin reject' do
    sign_in users(:admin)

    bulletins(:bulletin_with_image).to_moderate!
    patch reject_admin_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    assert_response :redirect
    assert_equal 'rejected', bulletins(:bulletin_with_image).reload.state
  end

  test 'bulletin invalid transition' do
    sign_in users(:admin)

    bulletins(:bulletin_with_image).to_moderate!
    bulletins(:bulletin_with_image).reject!

    assert_raises AASM::InvalidTransition do
      patch publish_admin_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    end
  end
end
