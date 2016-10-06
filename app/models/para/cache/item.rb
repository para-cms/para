# Borrowed from activesupport-db-cache gem (https://github.com/sergio-fry/activesupport-db-cache),
# which is out of date now not allowing us to depend on it in para
#
module Para
  module Cache
    class Item < ActiveRecord::Base
      def value
        Marshal.load(::Base64.decode64(self[:value])) if self[:value].present?
      end

      def value=(new_value)
        @raw_value = new_value
        self[:value] = ::Base64.encode64(Marshal.dump(@raw_value))
      end

      def expired?
        read_attribute(:expires_at).try(:past?) || false
      end

      # From ActiveSupport::Cache::Store::Entry
      # Seconds since the epoch when the entry will expire.
      def expires_at
        read_attribute(:expires_at).try(:to_f)
      end
    end
  end
end
