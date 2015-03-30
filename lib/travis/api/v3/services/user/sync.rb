module Travis::API::V3
  class Services::User::Sync < Service
    def run!
      query.sync if access_control.writable? find
    end
  end
end
