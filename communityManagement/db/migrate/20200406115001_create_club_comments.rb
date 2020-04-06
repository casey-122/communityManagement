class CreateClubComments < ActiveRecord::Migration[5.0]
  def change
    create_table :club_comments do |t|
      t.integer :yong_hu_id
      t.integer :club_id
      t.integer :status
      t.text :content
      t.integer :as_type
      t.integer :re_comment_id
      t.integer :re_reply_id

      t.timestamps
    end
  end
end
