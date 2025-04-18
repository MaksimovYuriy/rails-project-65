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

    patch publish_admin_bulletin_path(bulletins(:bulletin_on_moderate)), params: {}
    bulletins(:bulletin_on_moderate).reload

    assert { bulletins(:bulletin_on_moderate).published? }
  end

  test 'bulletin archive' do
    sign_in users(:admin)

    patch archive_admin_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    bulletins(:bulletin_with_image).reload

    assert { bulletins(:bulletin_with_image).archived? }
  end

  test 'bulletin reject' do
    sign_in users(:admin)

    patch reject_admin_bulletin_path(bulletins(:bulletin_on_moderate)), params: {}
    bulletins(:bulletin_on_moderate).reload

    assert { bulletins(:bulletin_on_moderate).rejected? }
  end

  test 'bulletin invalid transition' do
    sign_in users(:admin)

    assert_raises AASM::InvalidTransition do
      patch publish_admin_bulletin_path(bulletins(:bulletin_rejected)), params: {}
    end
  end
end
