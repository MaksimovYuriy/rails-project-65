# frozen_string_literal: true

# test/support/test_helpers.rb
module TestHelpers
  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: user.name
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def load_image(name, type = 'image/jpeg')
    image_path = Rails.root.join("test/fixtures/files/#{name}")
    fixture_file_upload(image_path, type)
  end
end

class ActiveSupport::TestCase
  include TestHelpers
end
