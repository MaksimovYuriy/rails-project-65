# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      before_action :authenticate_user!

      def index
        @categories = Category.all
        authorize @categories, policy_class: Web::Admin::CategoryPolicy
      end

      def new
        authorize Category, policy_class: Web::Admin::CategoryPolicy
        @category = Category.new
      end

      def edit
        @category = Category.find(params[:id])
        authorize @category, policy_class: Web::Admin::CategoryPolicy
      end

      def create
        authorize Category, policy_class: Web::Admin::CategoryPolicy
        @category = Category.new(category_params)

        if @category.save
          redirect_to admin_categories_path, notice: I18n.t('notices.categories.create')
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @category = Category.find(params[:id])
        authorize @category, policy_class: Web::Admin::CategoryPolicy

        if @category.update(category_params)
          redirect_to admin_categories_path, notice: I18n.t('notices.categories.update')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category = Category.find(params[:id])
        authorize @category, policy_class: Web::Admin::CategoryPolicy
        @category&.destroy!
        redirect_to admin_categories_path, notice: I18n.t('notices.categories.destroy')
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
