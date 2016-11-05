# This migration comes from para_engine (originally 20160419145254)
class CreateParaPageSections < ActiveRecord::Migration
  def change
    create_table :para_page_sections do |t|
      t.string :type
      t.jsonb :data
      t.integer :position, default: 0
      t.references :page, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
