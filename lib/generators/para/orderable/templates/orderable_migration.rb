class AddOrderablePositionTo<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :position, :integer, default: 0
    add_index :<%= table_name %>, :position
  end
end
