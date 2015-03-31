require 'sidekiq'

module Travis::API::V3
  module Extensions
    module Sidekiq
      module Client
        def push(item)
          Travis.logger.info("Sidekiq job scheduled: #{item.inspect}") if debug_push?
          super
        end

        def debug_push?
          Travis.env == 'development'.freeze or Travis.env == 'staging'.freeze
        end
      end

      ::Sidekiq::Client.send(:prepend, Client)
    end
  end
end
