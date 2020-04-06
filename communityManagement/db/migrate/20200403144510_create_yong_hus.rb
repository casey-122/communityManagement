class CreateYongHus < ActiveRecord::Migration[5.0]
  def change
    create_table :yong_hus do |t|
      t.string :user_id
      t.string :real_name
      t.string :sex
      t.string :phone
      t.date :birth

      t.timestamps
    end

  end
end
