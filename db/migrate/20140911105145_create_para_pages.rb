class CreateParaPages < ActiveRecord::Migration
  def change
    create_table :para_pages do |t|
      t.string :title
      t.string :slug, index: true
      t.text :content

      t.references :component, index: true

      t.timestamps
    end
  end
end
