module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create ]

        def index
            @search_query = Bulletin.ransack(params[:search_query])
            @bulletins = @search_query.result.where(aasm_state: 'published').order(created_at: :desc)
            authorize @bulletins, policy_class: Web::BulletinPolicy
        end

        def new
            @bulletin = current_user.bulletins.build
            authorize @bulletin, policy_class: Web::BulletinPolicy
        end

        def create
            authorize Bulletin, policy_class: Web::BulletinPolicy
            @bulletin = current_user.bulletins.build(bulletin_params)

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

        def profile
            @search_query = current_user.bulletins.ransack(params[:search_query])
            @bulletins = @search_query.result.order(created_at: :desc)
            authorize @bulletins, :profile?, policy_class: Web::BulletinPolicy
        end

        def to_moderate
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
            @bulletin.to_moderate!
            redirect_to profile_path           
        end

        def archive
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
            @bulletin.archive!
            redirect_to profile_path
        end

        private

        def bulletin_params
            params.require(:bulletin).permit(:title, :description, :category_id, :image)
        end
    end
end