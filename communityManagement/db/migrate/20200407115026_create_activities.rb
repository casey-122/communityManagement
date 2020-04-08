class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :club_id
      t.integer :yong_hu_id
      t.string :act_name
      t.text :act_describe
      t.date :start_time
      t.date :end_time
      t.string :act_address
      t.string :plan_url
      t.integer :status

      t.timestamps
    end
  end
end
