# This is a simple ActiveSupport::Cache::Store implementation, borrowed from
# activesupport-db-cache gem (https://github.com/sergio-fry/activesupport-db-cache),
# simplified.
#
# It also adds RequestStore.store caching, avoiding same key reads to hit
# ActiveRecord multiple times in a single request
#
# This is primarily meant to manage jobs status storing in Para::Job::Base
# through the ActiveJob::Status gem. It allows not to add external storage
# systems dependency (redis, memcache) to the app when not needed (when using
# default ActiveJob 5 AsyncAdapter or SuckerPunchAdapter).
#
# Since it's quite slow, it's advised to replace it with faster cache stores
# like Redis or Memcache when used in large production systems.
#
module Para
  module Cache
    class DatabaseStore < ActiveSupport::Cache::Store
      def clear
        Item.delete_all
      end

      def delete_entry(key, options)
        Item.delete_all(key: key)
      end

      def read_entry(key, options={})
        RequestStore.store[cache_key_for(key)] ||= Item.find_by(key: key)
      end

      def write_entry(key, entry, options)
        RequestStore.store[cache_key_for(key)] ||= Item.where(key: key).first_or_initialize
        item = RequestStore.store[cache_key_for(key)]

        options = options.clone.symbolize_keys

        item.value = entry.value
        item.expires_at = options[:expires_in].try(:since)
        item.save!

        # Ensure cached item in RequestStore is up to date
        RequestStore.store[cache_key_for(key)] = item
      rescue ActiveRecord::RecordNotUnique
      ensure
        clear_expired_keys
      end

      private

      def clear_expired_keys
        if Item.count > Para.config.database_cache_store_max_items
          remove_expired_items
          remove_old_items
        end
      end

      def remove_expired_items
        Item.where("expires_at < ?", Time.now).delete_all
      end

      def remove_old_items
        count = (Item.count - Para.config.database_cache_store_max_items)
        Item.order('updated_at ASC').limit(count).delete_all if count > 0
      end

      def cache_key_for(key)
        ['para.cache.database_store', key].join('.')
      end
    end
  end
end
