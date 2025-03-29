module Web
    module Admin
        class BulletinsController < Web::Admin::ApplicationController

            def index
                @bulletins = Bulletin.order(created_at: :desc)
                authorize @bulletins, policy_class: Web::Admin::BulletinPolicy
            end

        end
    end
end