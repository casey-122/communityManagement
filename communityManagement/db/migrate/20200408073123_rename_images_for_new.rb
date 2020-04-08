class RenameImagesForNew < ActiveRecord::Migration[5.0]
  def change
    rename_column :news, :images, :file_url
  end
end
