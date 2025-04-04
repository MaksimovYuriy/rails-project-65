class Web::ApplicationController < ApplicationController

    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def authenticate_user!
        unless session[:user_id].present?
            redirect_to root_path, alert: "Please log in to continue."
        end
    end

    helper_method :current_user
    helper_method :authenticate_user!

    private

    def user_not_authorized
        redirect_to root_path, alert: 'There are no administrator rights.'
    end

end