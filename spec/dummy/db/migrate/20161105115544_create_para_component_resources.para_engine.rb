# This migration comes from para_engine (originally 20150129170710)
class CreateParaComponentResources < ActiveRecord::Migration
  def change
    create_table :para_component_resources do |t|
      t.references :component, index: true
      t.references :resource, index: true, polymorphic: true

      t.timestamps null: false
    end

    add_foreign_key :para_component_resources, :para_components,
                    column: :component_id
  end
end
