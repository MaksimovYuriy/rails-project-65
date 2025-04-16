# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:bulletin_without_image)
    @bulletin.image = load_image('image.jpeg')
  end

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

    @bulletin.to_moderate!
    patch publish_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'published', @bulletin.reload.state
  end

  test 'bulletin archive' do
    sign_in users(:admin)

    @bulletin.to_moderate!
    @bulletin.publish!

    patch archive_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'archived', @bulletin.reload.state
  end

  test 'bulletin reject' do
    sign_in users(:admin)

    @bulletin.to_moderate!
    patch reject_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'rejected', @bulletin.reload.state
  end

  test 'bulletin invalid transition' do
    sign_in users(:admin)

    @bulletin.to_moderate!
    @bulletin.reject!

    assert_raises AASM::InvalidTransition do
      patch publish_admin_bulletin_path(@bulletin), params: {}
    end
  end
end
