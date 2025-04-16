# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      before_action :authorize_admin!

      def index
        @search_query = Bulletin.ransack(params[:search_query])
        @bulletins = @search_query.result
                                  .order(created_at: :desc)
                                  .page(params[:page])
      end

      def on_moderate
        @search_query = Bulletin.ransack(params[:search_query])
        @bulletins = @search_query.result
                                  .where(state: 'under_moderation')
                                  .order(created_at: :desc)
                                  .page(params[:page])
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
