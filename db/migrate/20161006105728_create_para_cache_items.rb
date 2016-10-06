class CreateParaCacheItems < ActiveRecord::Migration
  def change
    create_table :para_cache_items do |t|
      t.string :key
      t.text :value

      t.datetime :expires_at

      t.timestamps
    end
  end
end
