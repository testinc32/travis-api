module Travis::API::V3
  class Queries::Organization < Query
    params :id

    def find
      return Models::Organization.find_by_id(id) if id
      raise WrongParams, 'missing organization.id'.freeze
    end

    def sync(org = find)
      user_query = Queries::User.new(params, main_type)
      org.users.each { |user| user_query.sync(user) }
    end
  end
end
