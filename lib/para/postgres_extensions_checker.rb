module Para
  class PostgresExtensionsChecker
    class << self
      def check_all
        %w(hstore unaccent).each do |extname|
          unless extension_exists?(extname)
            # Could not use Rails.logger here, using puts as a temporary
            # solution.
            puts "[Warning] PostgreSQL \"#{ extname }\" extension is not " +
                 "installed in your database. This means that you " +
                 "missing some migrations that you can install " +
                 "with the following command : " +
                 "`rake para_engine:install:migrations` and then migrate."
          end
        end
      end

      private

      def extension_exists?(extname)
        ActiveRecord::Base.connection.execute(
          "SELECT COUNT(*) FROM pg_catalog.pg_extension " +
          "WHERE extname = '#{ extname }'"
        ).first['count'].to_i > 0
      rescue ActiveRecord::NoDatabaseError
        true # Do not issue warning when no database is installed
      end
    end
  end
end
