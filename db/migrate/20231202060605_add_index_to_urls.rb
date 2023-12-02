class AddIndexToUrls < ActiveRecord::Migration[7.1]
  def change
    add_index :urls, :original_url
  end
end
