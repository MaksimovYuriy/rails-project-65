# frozen_string_literal: true

require 'pundit'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest

  test 'index page' do
    get root_url
    assert_response :success
  end

  test 'new bulletin page without user' do
    get new_bulletin_path
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'new bulletin page with user' do
    sign_in users(:user)
    get new_bulletin_path
    assert_response :success
  end

  test 'new bulletin without image and category' do
    sign_in users(:user)

    attrs_without_image = { category_id: categories(:category2)[:id],
                            description: 'test description',
                            title: 'test title' }

    post bulletins_url, params: { bulletin: attrs_without_image }

    bulletin = Bulletin.find_by attrs_without_image
    assert { bulletin.nil? }
  end

  test 'new bulletin' do
    sign_in users(:user)

    attrs = {
      category_id: categories(:category2)[:id],
      description: 'test description',
      title: 'test title',
      image: load_image('image.jpeg')
    }

    post bulletins_url, params: { bulletin: attrs }

    bulletin = Bulletin.find_by title: attrs[:title]
    assert { bulletin }
  end

  test 'show page without user' do
    get bulletin_path(bulletins(:bulletin_with_image))
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'show page with user (published)' do
    sign_in users(:user)

    get bulletin_path(bulletins(:bulletin1))
    assert_response :success
  end

  test 'show page with user (draft)' do
    sign_in users(:user)

    get bulletin_path(bulletins(:bulletin_with_image))
    assert_response :success
  end

  test 'edit page (user - is owner)' do
    sign_in users(:user)

    get edit_bulletin_path(bulletins(:bulletin_with_image))
    assert_response :success
  end

  test 'edit page (user - is not owner)' do
    sign_in users(:user)

    get edit_bulletin_path(bulletins(:bulletin3))
    assert_redirected_to root_path(locale: I18n.default_locale)
  end

  test 'update bulletin' do
    sign_in users(:user)
    updated_attrs = {
      title: 'updated title',
      image: load_image('image.jpeg')
    }

    patch bulletin_path(bulletins(:bulletin_with_image)), params: { bulletin: updated_attrs }
    assert_redirected_to bulletin_path(bulletins(:bulletin_with_image), locale: I18n.default_locale)

    bulletins(:bulletin_with_image).reload
    assert_equal bulletins(:bulletin_with_image).title, 'updated title'
  end

  test 'bulletin states (archived)' do
    sign_in users(:user)

    bulletins(:bulletin_with_image).to_moderate!

    patch archive_bulletin_path(bulletins(:bulletin_with_image)), params: {}
    assert_response :redirect
    assert_equal 'archived', bulletins(:bulletin_with_image).reload.state
  end
end
