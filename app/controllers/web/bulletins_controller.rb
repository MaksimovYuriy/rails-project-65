module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create ]

        def index
            @bulletins = Bulletin.order(created_at: :desc)
            authorize @bulletins
        end

        def new
            @bulletin = current_user.bulletins.build
            authorize @bulletin
        end

        def create
            authorize Bulletin
            @bulletin = current_user.bulletins.build(bulletin_params)

            if @bulletin.save
                redirect_to root_path, notice: 'Bulletin was successfully created.'
            else
                redirect_to root_path, notice: 'Some error on creating.'
            end
        end

        def show
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin
        end

        private

        def bulletin_params
            params.require(:bulletin).permit(:title, :description, :category_id, :image)
        end
    end
end