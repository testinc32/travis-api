module Travis::API::V3
  class Sidekiq
    def self.client
      @client ||= ::Sidekiq::Client
    end

    def self.client=(value)
      @client = value
    end

    attr_accessor :class_name, :queue, :identifier
    attr_writer :client

    def initialize(identifier, class_name: nil, queue: nil, client: nil)
      @identifier = identifier
      @class_name = class_name || identifier
      @class_name = "Travis::Sidekiq::%s".freeze % @class_name.to_s.camelcase if @class_name.is_a? Symbol
      @queue      = queue.to_s || "default".freeze
      @client     = client
    end

    def client
      @client || self.class.client
    end

    def perform_async(*args)
      client.push('queue'.freeze => queue, 'class'.freeze => class_name, 'args'.freeze => args)
    end
  end
end