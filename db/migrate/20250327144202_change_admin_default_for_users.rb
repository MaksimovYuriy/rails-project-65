class ChangeAdminDefaultForUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :admin, from: nil, to: false
  end
end
