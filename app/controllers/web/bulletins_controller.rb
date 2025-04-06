module Web
    class BulletinsController < Web::ApplicationController
        before_action :authenticate_user!, only: %i[ new create edit update profile ]

        def index
            @search_query = Bulletin.ransack(params[:search_query])
            @bulletins = @search_query.result
                .where(aasm_state: 'published')
                .order(created_at: :desc)
                .page(params[:page])
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
                redirect_to root_path, notice: I18n.t('notices.bulletins.create')
            else
                render :new, status: :unprocessable_entity
            end
        end

        def show
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
        end

        def edit
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
        end

        def update
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, policy_class: Web::BulletinPolicy
            
            if @bulletin.update(bulletin_params)
                redirect_to bulletin_path(@bulletin), notice: I18n.t('notices.bulletins.update')
            else
                render :edit, status: :unprocessable_entity
            end
        end

        def profile
            @search_query = current_user.bulletins.ransack(params[:search_query])
            @bulletins = @search_query.result
                                     .order(created_at: :desc)
                                     .page(params[:page])
            @bulletins.each do |bulletin|
              authorize bulletin, :profile?, policy_class: Web::BulletinPolicy
            end  
        end
          

        def to_moderate
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, :to_moderate? , policy_class: Web::BulletinPolicy
            if @bulletin.to_moderate!
                redirect_to profile_path, notice: 'Bulletin sent to moderation.'
            else
                redirect_to profile_path, alert: 'Failed to send bulletin to moderation.'
            end       
        end

        def archive
            @bulletin = Bulletin.find(params[:id])
            authorize @bulletin, :archive?, policy_class: Web::BulletinPolicy
            @bulletin.archive!
            redirect_to profile_path
        end

        private

        def bulletin_params
            params.require(:bulletin).permit(:title, :description, :category_id, :image)
        end
    end
end