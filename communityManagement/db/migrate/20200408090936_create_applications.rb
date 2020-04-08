class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.integer :yong_hu_id
      t.integer :club_id
      t.integer :status

      t.timestamps
    end
  end
end
