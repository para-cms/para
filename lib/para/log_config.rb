module Para
  class LogConfig
    def self.with_log_level(level, &block)
      begin
        log_level = Rails.logger.level
        Rails.logger.level = :fatal

        block.call
      ensure
        Rails.logger.level = log_level
      end
    end
  end
end
