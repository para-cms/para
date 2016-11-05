# This migration comes from para_engine (originally 20160304113055)
class AddJsonEqualityOperatorPatchToPostgres < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
      -- This creates a function named hashjson that transforms the
      -- json to texts and generates a hash
      CREATE OR REPLACE FUNCTION hashjson(
          json
      ) RETURNS INTEGER LANGUAGE SQL STRICT IMMUTABLE AS $$
          SELECT hashtext($1::text);
      $$;

      -- This creates a function named json_eq that checks equality (as text)
      CREATE OR REPLACE FUNCTION json_eq(
          json,
          json
      ) RETURNS BOOLEAN LANGUAGE SQL STRICT IMMUTABLE AS $$
          SELECT bttextcmp($1::text, $2::text) = 0;
      $$;

      -- This creates an operator from the equality function
      CREATE OPERATOR = (
          LEFTARG   = json,
          RIGHTARG  = json,
          PROCEDURE = json_eq
      );

      -- Finaly, this defines a new default JSON operator family with the
      -- operators and functions we just defined.
      CREATE OPERATOR CLASS json_ops
         DEFAULT FOR TYPE json USING hash AS
         OPERATOR 1  =,
         FUNCTION 1  hashjson(json);
    SQL
  end

  def down
  end
end
