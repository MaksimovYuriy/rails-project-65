# frozen_string_literal: true

module Web
  module Admin
    class CategoryPolicy < ApplicationPolicy
      def index?
        user&.admin?
      end

      def new?
        user&.admin?
      end

      def create?
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
    end
  end
end
