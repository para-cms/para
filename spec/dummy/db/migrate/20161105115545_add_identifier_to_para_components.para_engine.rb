# This migration comes from para_engine (originally 20150203173219)
class AddIdentifierToParaComponents < ActiveRecord::Migration
  def change
    add_column :para_components, :identifier, :string
  end
end
