# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_or_create_by(email: auth.info.email) do |u|
        u.name = auth.info.name
      end
      session[:user_id] = user.id
      session[:user_admin] = user.admin?
      redirect_to root_path, notice: "#{I18n.t('notices.auth.logged')} #{user.name}"
    end

    def logout
      session[:user_id] = nil
      session[:user_admin] = nil
      redirect_to root_path, notice: I18n.t('notices.auth.logout')
    end
  end
end
