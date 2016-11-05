# This migration comes from para_engine (originally 20140911091225)
class CreateParaComponents < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'

    create_table :para_components do |t|
      t.string :type
      t.string :name
      t.hstore :configuration, default: '', null: false
      t.integer :position, default: 0
      t.integer :component_section_id

      t.timestamps
    end
  end

  def down
    drop_table :para_components
  end
end
