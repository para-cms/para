class CreateParaComponentSections < ActiveRecord::Migration
  def change
    create_table :para_component_sections do |t|
      t.string :name
      t.timestamps
    end
  end
end
