module Web
    module Admin
        class BulletinPolicy < ApplicationPolicy
            def index?
                user&.admin?
            end

            def on_moderate?
                user&.admin?
            end

            def new?
                user&.admin?
            end

            def create?
                user&.admin?
            end

            def show?
                user&.admin?
            end

            def edit?
                user&.admin?
            end

            def update?
                user&.admin?
            end

            def destroy?
                user&.admin?
            end

            def to_moderate?
                user&.admin?
            end

            def reject?
                user&.admin?
            end

            def publish?
                user&.admin?
            end

            def archive?
                user&.admin?
            end
        end
    end
end
