# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attrs = { category_id: categories(:category1)[:id],
               description: 'test description',
               title: 'test title',
               user: users(:user),
               image: load_image('image.jpeg') }
    @bulletin = Bulletin.create!(@attrs)
  end

  test 'admin page (user.admin == false)' do
    sign_in users(:user)
    get admin_path
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'admin page (user.admin == true)' do
    sign_in users(:admin)
    get admin_path
    assert_response :success
  end

  test 'bulletin states (admin == true) - publish' do
    sign_in users(:admin)

    patch to_moderate_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'under_moderation', @bulletin.reload.state

    patch publish_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'published', @bulletin.reload.state

    patch archive_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'archived', @bulletin.reload.state
  end

  test 'bulletin states (admin == true) - reject' do
    sign_in users(:admin)

    patch to_moderate_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'under_moderation', @bulletin.reload.state

    patch reject_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'rejected', @bulletin.reload.state

    assert_raises AASM::InvalidTransition do
      patch publish_admin_bulletin_path(@bulletin), params: {}
    end

    patch archive_admin_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'archived', @bulletin.reload.state
  end
end
