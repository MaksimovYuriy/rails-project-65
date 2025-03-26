module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create ]

        def index
            @bulletins = Bulletin.order(created_at: :desc)
        end

        def new
            @bulletin = Bulletin.new
        end

        def create
            @bulletin = current_user.bulletins.build(bulletin_params)

            if @bulletin.save
                @bulletin.image.variant(resize_to_limit: [800, 800]).processed if @bulletin.image.attached?
                redirect_to root_path, notice: 'Bulletin was successfully created.'
            else
                redirect_to root_path, notice: 'Some error on creating.'
            end
        end

        def show
        end

        private

        def bulletin_params
            params.require(:bulletin).permit(:title, :description, :category_id, :image)
        end

        def authenticate_user!
            unless session[:user_id].present?
                redirect_to root_path, alert: "Please log in to continue."
            end
        end
    end
end