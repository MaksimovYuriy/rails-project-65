# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      before_action :authorize_admin!

      def index
        @categories = Category.all
      end

      def new
        @category = Category.new
      end

      def edit
        @category = Category.find(params[:id])
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          redirect_to admin_categories_path, notice: I18n.t('notices.categories.create')
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @category = Category.find(params[:id])

        if @category.update(category_params)
          redirect_to admin_categories_path, notice: I18n.t('notices.categories.update')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category = Category.find(params[:id])

        if @category.bulletins.empty?
          @category.destroy!
          redirect_to admin_categories_path, notice: I18n.t('notices.categories.destroy')
        else
          redirect_to admin_categories_path, alert: I18n.t('notices.categories.destroy_error')
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
