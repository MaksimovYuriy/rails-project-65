# frozen_string_literal: true

module Web
  class ProfileController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @search_query = current_user.bulletins.ransack(params[:search_query])
      @bulletins = @search_query.result
                                .order(created_at: :desc)
                                .page(params[:page])
    end
  end
end
