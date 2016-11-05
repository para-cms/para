# This migration comes from para_engine (originally 20140911112150)
class AddSlugToParaComponents < ActiveRecord::Migration
  def change
    add_column :para_components, :slug, :string
    add_index :para_components, :slug
  end
end
