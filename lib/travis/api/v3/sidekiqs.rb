module Travis::API::V3
  module Sidekiqs
    extend ConstantResolver

    BuildRequest = Sidekiq.new(:build_request,    queue: :build_requests)
    SyncUser     = Sidekiq.new(:synchronize_user, queue: :user_sync)
  end
end
