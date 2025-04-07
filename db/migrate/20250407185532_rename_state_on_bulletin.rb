class RenameStateOnBulletin < ActiveRecord::Migration[7.2]
  def change
    rename_column :bulletins, :aasm_state, :state
  end
end
