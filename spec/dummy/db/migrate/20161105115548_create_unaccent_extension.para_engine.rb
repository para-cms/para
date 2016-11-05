# This migration comes from para_engine (originally 20160613172154)
class CreateUnaccentExtension < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS unaccent')
  end
end
