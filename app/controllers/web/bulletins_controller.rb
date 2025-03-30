module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create ]

        def index
            @bulletins = Bulletin.where(aasm_state: 'published').order(created_at: :desc)
            authorize @bulletins, policy_class: Web::BulletinPolicy
        end

        def new
            @bulletin = current_user.bulletins.build
            authorize @bulletin, policy_class: Web::BulletinPolicy
        end

        def create
            authorize Bulletin, policy_class: Web::BulletinPolicy
            @bulletin = current_user.bulletins.build(bulletin_params)
            @bulletin.to_moderate

            if @bulletin.save
                redirect_to root_path, notice: 'Bulletin was successfully created.'
            else
                redirect_to root_path, notice: 'Some error on creating.'
            end
        end

        def show
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
        end

        private

        def bulletin_params
            params.require(:bulletin).permit(:title, :description, :category_id, :image)
        end
    end
end