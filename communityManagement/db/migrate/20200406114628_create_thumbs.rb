class CreateThumbs < ActiveRecord::Migration[5.0]
  def change
    create_table :thumbs do |t|
      t.integer :yong_hu_id
      t.integer :club_id
      t.boolean :is_thumb

      t.timestamps
    end
  end
end
