class AddIdentifierToParaComponentSections < ActiveRecord::Migration
  def change
    add_column :para_component_sections, :identifier, :string
  end
end
