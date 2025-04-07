require "pundit"

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @attrs = { category_id: categories(:category1)[:id],
                description: 'test description',
                title: 'test title',
                user: users(:user),
                image: load_image('image.jpeg') }
      @bulletin = Bulletin.create!(@attrs)
    end

    test "index page" do
        get root_url
        assert_response :success
    end

    test "bulletin states (admin == false)" do
      debugger
    end
end
