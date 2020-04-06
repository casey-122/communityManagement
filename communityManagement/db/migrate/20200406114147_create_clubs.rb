class CreateClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs do |t|
      t.string :club_name
      t.string :club_email
      t.text :club_brief
      t.date :found_time
      t.string :activity_num
      t.references :yong_hu, foreign_key: true

      t.timestamps
    end
  end
end
