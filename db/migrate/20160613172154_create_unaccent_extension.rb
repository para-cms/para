class CreateUnaccentExtension < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS unaccent')
  end
end
