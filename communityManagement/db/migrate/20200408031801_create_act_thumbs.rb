class CreateActThumbs < ActiveRecord::Migration[5.0]
  def change
    create_table :act_thumbs do |t|
      t.integer :yong_hu_id
      t.integer :act_id
      t.boolean :is_thumb

      t.timestamps
    end
  end
end
