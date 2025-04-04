module Web
    module Admin
        class CategoriesController < Web::Admin::ApplicationController

            def index
                @categories = Category.all
                authorize @categories, policy_class: Web::Admin::CategoryPolicy
            end

            def new
                authorize Category, policy_class: Web::Admin::CategoryPolicy
                @category = Category.new
            end

            def create
                authorize Category, policy_class: Web::Admin::CategoryPolicy
                @category = Category.new(category_params)

                if @category.save
                    redirect_to admin_categories_path, notice: 'Category succesfully created.'
                else
                    redirect_to root_path, notice: 'Some error.'
                end
            end

            def edit
                @category = Category.find(params[:id])
                authorize @category, policy_class: Web::Admin::CategoryPolicy
            end

            def update
                @category = Category.find(params[:id])
                authorize @category, policy_class: Web::Admin::CategoryPolicy

                if @category.update(category_params)
                    redirect_to admin_categories_path, notice: 'Category succesfully updated.'
                else
                    redirect_to root_path, notice: 'Some error.'
                end
            end

            def destroy
                @category = Category.find(params[:id])
                authorize @category, policy_class: Web::Admin::CategoryPolicy
                @category&.destroy!
                redirect_to admin_categories_path, notice: 'Category succesfully deleted.'
            end

            private 
            
            def category_params
                params.require(:category).permit(:name)
            end

        end
    end
end