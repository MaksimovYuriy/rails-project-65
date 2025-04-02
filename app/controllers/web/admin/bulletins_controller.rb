module Web
    module Admin
        class BulletinsController < Web::Admin::ApplicationController

            def index
                @search_query = Bulletin.ransack(params[:search_query])
                @bulletins = @search_query.result.order(created_at: :desc)
                authorize @bulletins, policy_class: Web::Admin::BulletinPolicy
            end

            def to_moderate
                @bulletin = Bulletin.find(params[:id])
                @bulletin.to_moderate!
                redirect_to admin_bulletins_path
            end

            def reject
                @bulletin = Bulletin.find(params[:id])
                @bulletin.reject!
                redirect_to admin_bulletins_path                
            end

            def publish
                @bulletin = Bulletin.find(params[:id])
                @bulletin.publish!
                redirect_to admin_bulletins_path
            end

            def archive
                @bulletin = Bulletin.find(params[:id])
                @bulletin.archive!
                redirect_to admin_bulletins_path
            end

        end
    end
end