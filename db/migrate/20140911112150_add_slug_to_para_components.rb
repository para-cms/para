class AddSlugToParaComponents < ActiveRecord::Migration
  def change
    add_column :para_components, :slug, :string
    add_index :para_components, :slug
  end
end
