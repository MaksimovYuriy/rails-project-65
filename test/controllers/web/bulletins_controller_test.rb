# frozen_string_literal: true

require 'pundit'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attrs = { category_id: categories(:category1)[:id],
               description: 'test description',
               title: 'test title',
               user: users(:user),
               image: load_image('image.jpeg') }
    @bulletin = Bulletin.create!(@attrs)
  end

  test 'index page' do
    get root_url
    assert_response :success
  end

  test 'profile page' do
    get profile_path
    assert_redirected_to root_path

    sign_in users(:user)
    get profile_path
    assert_response :success
  end

  test 'new bulletin page' do
    get new_bulletin_path
    assert_redirected_to root_path

    sign_in users(:user)
    get new_bulletin_path
    assert_response :success
  end

  test 'new bulletin without image' do
    sign_in users(:user)

    attrs_without_image = { category_id: categories(:category2)[:id],
                            description: 'test description',
                            title: 'test title' }

    post bulletins_url, params: { bulletin: attrs_without_image }

    bulletin = Bulletin.find_by attrs_without_image
    assert { bulletin.nil? }
  end

  test 'update bulletin' do
    sign_in users(:user)
    updated_attrs = {
      title: 'updated title'
    }

    patch bulletin_path(@bulletin), params: { bulletin: updated_attrs }
    assert_redirected_to bulletin_path(@bulletin)

    @bulletin.reload
    assert_equal @bulletin.title, 'updated title'
  end

  test 'bulletin states (admin == false)' do
    sign_in users(:user)

    patch to_moderate_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'under_moderation', @bulletin.reload.state

    patch publish_admin_bulletin_path(@bulletin), params: {}
    assert_equal 'under_moderation', @bulletin.reload.state

    patch archive_bulletin_path(@bulletin), params: {}
    assert_response :redirect
    assert_equal 'archived', @bulletin.reload.state
  end
end
