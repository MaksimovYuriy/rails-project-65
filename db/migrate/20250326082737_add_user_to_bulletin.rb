class AddUserToBulletin < ActiveRecord::Migration[7.2]
  def change
    add_reference :bulletins, :user, foreign_key: true
  end
end
