# frozen_string_literal: true

module Web
  class ProfilesController < Web::ApplicationController
    before_action :authenticate_user!

    def show
      @search_query = current_user.bulletins.ransack(params[:search_query])
      @bulletins = @search_query.result
                                .order(created_at: :desc)
                                .page(params[:page])
    end
  end
end
