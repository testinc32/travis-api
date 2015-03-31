module Travis::API::V3
  class Queries::User < Query
    params :id

    def find
      return Models::User.find_by_id(id) if id
      raise WrongParams, 'missing user.id'.freeze
    end

    def sync(user = find, force: false)
      return false if user.syncing? and not force
      perform_async(:sync_user, user)
      user.update_column(:is_syncing, true)
      true
    end
  end
end
