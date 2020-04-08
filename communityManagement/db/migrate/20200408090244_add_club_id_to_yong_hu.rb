class AddClubIdToYongHu < ActiveRecord::Migration[5.0]
  def change
    add_column :yong_hus, :club_id, :integer
  end
end
