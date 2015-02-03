class AddIdentifierToParaComponents < ActiveRecord::Migration
  def change
    add_column :para_components, :identifier, :string
  end
end
