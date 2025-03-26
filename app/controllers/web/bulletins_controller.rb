module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create ]

        def index
            @bulletins = Bulletin.order(created_at: :desc)
        end

        def new
        end

        def create
        end

        def show
        end

        private

        def authenticate_user!
            unless session[:user_id].present?
                redirect_to auth_request_path, alert: "Please log in to continue."
            end
        end
    end
end