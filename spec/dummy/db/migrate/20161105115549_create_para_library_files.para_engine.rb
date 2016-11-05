# This migration comes from para_engine (originally 20160905134106)
class CreateParaLibraryFiles < ActiveRecord::Migration
  def change
    create_table :para_library_files do |t|
      t.attachment :attachment

      t.timestamps null: false
    end
  end
end
