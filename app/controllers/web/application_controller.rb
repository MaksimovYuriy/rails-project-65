class Web::ApplicationController < ApplicationController

    include Pundit::Authorization

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    helper_method :current_user

end