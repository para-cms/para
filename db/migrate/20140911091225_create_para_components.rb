class CreateParaComponents < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'

    create_table :para_components do |t|
      t.string :type
      t.string :name
      t.hstore :configuration, default: {}
      t.integer :position, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :para_components
  end
end
