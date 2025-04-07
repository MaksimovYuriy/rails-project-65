module Web
    module Admin
        class BulletinsController < Web::Admin::ApplicationController
            before_action :authenticate_user!

            def index
                authorize Bulletin, policy_class: Web::Admin::BulletinPolicy
                @search_query = Bulletin.ransack(params[:search_query])
                @bulletins = @search_query.result
                    .order(created_at: :desc)
                    .page(params[:page])
            end

            def on_moderate
                authorize Bulletin, policy_class: Web::Admin::BulletinPolicy
                @search_query = Bulletin.ransack(params[:search_query])
                @bulletins = @search_query.result
                    .where(state: "under_moderation")
                    .order(created_at: :desc)
                    .page(params[:page])
            end

            def to_moderate
                @bulletin = Bulletin.find(params[:id])
                authorize @bulletin, policy_class: Web::Admin::BulletinPolicy
                @bulletin.to_moderate!
                redirect_to admin_bulletins_path
            end

            def reject
                @bulletin = Bulletin.find(params[:id])
                authorize @bulletin, policy_class: Web::Admin::BulletinPolicy
                @bulletin.reject!
                redirect_to admin_bulletins_path
            end

            def publish
                @bulletin = Bulletin.find(params[:id])
                authorize @bulletin, policy_class: Web::Admin::BulletinPolicy
                @bulletin.publish!
                redirect_to admin_bulletins_path
            end

            def archive
                @bulletin = Bulletin.find(params[:id])
                authorize @bulletin, policy_class: Web::Admin::BulletinPolicy
                @bulletin.archive!
                redirect_to admin_bulletins_path
            end
        end
    end
end
