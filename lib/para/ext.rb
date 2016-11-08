module Para
  # References all framework extensions to make our code work well with other
  # libraries.
  #
  # One goal is to have the minimum of them, but sometimes, without them, we
  # may need to make our own code dirty
  #
  module Ext
  end
end

require 'para/ext/cancan'
require 'para/ext/paperclip'
require 'para/ext/active_job_status'
