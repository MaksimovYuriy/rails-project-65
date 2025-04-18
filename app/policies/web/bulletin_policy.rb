# frozen_string_literal: true

module Web
  class BulletinPolicy < ApplicationPolicy
    def show?
      user&.id == record.user_id || record.published? || user&.admin?
    end

    def edit?
      record.user_id == user.id
    end

    def update?
      record.user_id == user.id
    end

    def to_moderate?
      record.user_id == user.id
    end

    def archive?
      record.user_id == user.id
    end
  end
end
