class AddStatusToClubs < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :status, :integer
  end
end
