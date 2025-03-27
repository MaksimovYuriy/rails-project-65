class UpdateValueAdminForUser < ActiveRecord::Migration[7.2]
  def up
    target_user = User.find_by name: 'MaksimovYuriy'
    if target_user.present?
      target_user.update! admin: true
    end
  end

  def down
    target_user = User.find_by name: 'MaksimovYuriy'
    if target_user.present?
      target_user.update! admin: false
    end
  end
end
