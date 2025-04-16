# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_or_create_by(email: auth.info.email)
      user.update(name: auth.info.name)
      session[:user_id] = user.id
      redirect_to root_path, notice: "#{I18n.t('notices.auth.logged')} #{user.name}"
    end

    def logout
      session[:user_id] = nil
      redirect_to root_path, notice: I18n.t('notices.auth.logout')
    end

    def failure
      session[:user_id] = nil
      redirect_to root_path, notice: I18n.t('notices.auth.failure')
    end
  end
end
