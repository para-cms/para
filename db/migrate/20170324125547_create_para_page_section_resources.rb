class CreateParaPageSectionResources < ActiveRecord::Migration
  def change
    create_table :para_page_section_resources do |t|
      t.references :section
      t.references :resource, polymorphic: true, index: false
      t.integer :position, default: 0
      t.jsonb :data

      t.timestamps
    end

    add_index :para_page_section_resources, [:resource_type, :resource_id], name: :index_para_section_resources_on_resource_type_and_id
    add_foreign_key :para_page_section_resources, :para_page_sections, column: 'section_id'
  end
end
