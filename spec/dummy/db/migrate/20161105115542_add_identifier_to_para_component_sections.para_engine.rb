# This migration comes from para_engine (originally 20140929131111)
class AddIdentifierToParaComponentSections < ActiveRecord::Migration
  def change
    add_column :para_component_sections, :identifier, :string
  end
end
