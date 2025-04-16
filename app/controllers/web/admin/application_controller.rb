# frozen_string_literal: true

module Web
  module Admin
    class ApplicationController < Web::ApplicationController

      helper_method :authorize_admin!

      def authorize_admin!
        return if current_user&.admin?

        redirect_to root_path, alert: I18n.t('notices.application.no_admin_rights')
      end

    end
  end
end
