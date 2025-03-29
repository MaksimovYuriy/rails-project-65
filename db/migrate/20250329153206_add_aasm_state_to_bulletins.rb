class AddAasmStateToBulletins < ActiveRecord::Migration[7.2]
  def change
    add_column :bulletins, :aasm_state, :string
  end
end
