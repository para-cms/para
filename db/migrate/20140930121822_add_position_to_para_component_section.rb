class AddPositionToParaComponentSection < ActiveRecord::Migration
  def change
    add_column :para_component_sections, :position, :integer
  end
end
