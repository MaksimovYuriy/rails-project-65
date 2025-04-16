# frozen_string_literal: true

module Web
  class BulletinsController < Web::ApplicationController
    before_action :authenticate_user!, only: %i[new create edit update profile]

    def index
      @search_query = Bulletin.ransack(params[:search_query])
      @bulletins = @search_query.result
                                .where(state: 'published')
                                .order(created_at: :desc)
                                .page(params[:page])
    end

    def show
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin, policy_class: Web::BulletinPolicy
    end

    def new
      @bulletin = current_user.bulletins.build
    end

    def edit
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin, policy_class: Web::BulletinPolicy
    end

    def create
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to root_path, notice: I18n.t('notices.bulletins.create')
      else
        render :new, status: :unprocessable_entity
      end
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
    end

    def to_moderate
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin, :to_moderate?, policy_class: Web::BulletinPolicy
      begin
        @bulletin.to_moderate!
        redirect_to profile_path, notice: I18n.t('notices.bulletins.send_to_moderation')
      rescue AASM::InvalidTransition
        redirect_to profile_path, alert: I18n.t('notices.bulletins.faild_to_moderation')
      end
    end

    def archive
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin, :archive?, policy_class: Web::BulletinPolicy
      @bulletin.archive!
      redirect_to profile_index_path
    end

    private

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
