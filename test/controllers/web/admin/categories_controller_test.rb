# frozen_string_literal: true

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test 'new category' do
    attrs = {
      name: 'test category'
    }
    post admin_categories_path, params: { category: attrs }
    category = Category.find_by attrs
    assert_equal category.name, 'test category'
  end

  test 'update category' do
    category = categories(:category1)
    updated_attrs = {
      name: 'Updated'
    }
    patch admin_category_path(category), params: { category: updated_attrs }
    assert_redirected_to admin_categories_path

    category.reload
    assert_equal category.name, 'Updated'
  end

  test 'destroy category' do
    category = categories(:category1)
    category_name = category.name
    delete admin_category_path(category)
    category = Category.find_by name: category_name
    assert { category.nil? }
  end
end
