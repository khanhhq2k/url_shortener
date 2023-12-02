class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :hash_value, index: { unique: true, name: 'unique_hash_values' }
      t.string :original_url
      t.datetime :expired_at
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
