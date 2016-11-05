# This migration comes from para_engine (originally 20140929125733)
class CreateParaComponentSections < ActiveRecord::Migration
  def change
    create_table :para_component_sections do |t|
      t.string :name
      t.timestamps
    end
  end
end
