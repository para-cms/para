# This migration comes from para_engine (originally 20140930121822)
class AddPositionToParaComponentSection < ActiveRecord::Migration
  def change
    add_column :para_component_sections, :position, :integer
  end
end
