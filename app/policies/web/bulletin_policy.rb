class Web::BulletinPolicy < ApplicationPolicy

    def index?
        true
    end

    def new?
        user
    end

    def create?
        user
    end

    def show?
        true
    end

    def edit?
        record.user_id == user.id
    end

    def update?
        record.user_id == user.id
    end

    def destroy?
        user&.admin? || record.user_id == user.id 
    end

    def profile?
        user
    end

    def to_moderate?
        record.user_id == user.id
    end

    def archive?
        record.user_id == user.id
    end

end