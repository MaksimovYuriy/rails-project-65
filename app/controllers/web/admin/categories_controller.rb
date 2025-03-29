module Web
    module Admin
        class CategoriesController < Web::Admin::ApplicationController

            def index
                @categories = Category.all
                authorize @categories
            end

            def new
                authorize Category
                @category = Category.new
            end

            def create
                authorize Category
                @category = Category.new(category_params)

                if @category.save
                    redirect_to categories_path, notice: 'Category succesfully created.'
                else
                    redirect_to root_path, notice: 'Some error.'
                end
            end

            def edit
                @category = Category.find(params[:id])
                authorize @category
            end

            def update
                @category = Category.find(params[:id])
                authorize @category

                if @category.update(category_params)
                    redirect_to categories_path, notice: 'Category succesfully updated.'
                else
                    redirect_to root_path, notice: 'Some error.'
                end
            end

            def destroy
                @category = Category.find(params[:id])
                @category&.destroy!
                redirect_to categories_path, notice: 'Category succesfully deleted.'
            end

            private 
            
            def category_params
                params.require(:category).permit(:name)
            end

        end
    end
end