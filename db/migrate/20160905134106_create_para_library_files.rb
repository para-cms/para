class CreateParaLibraryFiles < ActiveRecord::Migration
  def change
    create_table :para_library_files do |t|
      t.attachment :attachment

      t.timestamps null: false
    end
  end
end
