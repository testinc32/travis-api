module Travis::API::V3
  class Services::Organization::Sync < Service
    def run!
      query.sync if access_control.writable? find
    end
  end
end
