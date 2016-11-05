# This migration comes from para_engine (originally 20161006105728)
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
