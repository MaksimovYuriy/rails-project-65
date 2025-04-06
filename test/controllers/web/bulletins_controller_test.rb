require 'pundit'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest

    setup do

    end

    test 'policy loads correctly' do
      user = users(:user)
      bulletin = bulletins(:bulletin2)
    
      # Проверяем, что политика существует для bulletin
      policy = Pundit.policy(user, bulletin)
      assert_instance_of(Web::BulletinPolicy, policy)
    end

    test 'index page' do
        get root_url
        assert_response :success
    end

    test 'bulletin states (admin == false)' do
      sign_in users(:user)
      bulletin = bulletins(:bulletin2)
    
      patch to_moderate_bulletin_path(bulletin), params: {}
      assert_response :redirect
      assert_equal 'under_moderation', bulletin.reload.aasm_state
    end
      
end