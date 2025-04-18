# frozen_string_literal: true

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test 'categories admin page' do
    get admin_categories_path
    assert_response :success
  end

  test 'new category page' do
    get new_admin_category_path
    assert_response :success
  end

  test 'create category' do
    attrs = {
      name: 'test category'
    }
    post admin_categories_path, params: { category: attrs }
    category = Category.find_by attrs
    assert { category }
  end

  test 'edit category page' do
    get edit_admin_category_path(categories(:category1))
    assert_response :success
  end

  test 'update category' do
    category = categories(:category1)
    updated_attrs = {
      name: 'Updated'
    }
    patch admin_category_path(category), params: { category: updated_attrs }
    assert_redirected_to admin_categories_path(locale: I18n.default_locale)

    category.reload
    assert_equal category.name, 'Updated'
  end

  test 'destroy category (with bulletins)' do
    category = categories(:category1)
    category_name = category.name
    delete admin_category_path(category)
    category = Category.find_by name: category_name
    assert { category }
  end

  test 'destroy category (without bulletins)' do
    category_name = categories(:category_without_bulletins)[:name]
    delete admin_category_path(categories(:category_without_bulletins))
    category = Category.find_by name: category_name
    assert_nil category
  end
end
