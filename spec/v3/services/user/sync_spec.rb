require 'spec_helper'

describe Travis::API::V3::Services::User::Find do
  let(:user) { User.find_by_login('svenfuchs') }

  let(:token)   { Travis::Api::App::AccessToken.create(user: user, app_id: 1) }
  let(:headers) {{ 'HTTP_AUTHORIZATION' => "token #{token}"                  }}

  before do
    Travis::Features.stubs(:owner_active?).returns(true)
    @original_sidekiq = Sidekiq::Client
    Sidekiq.send(:remove_const, :Client) # to avoid a warning
    Sidekiq::Client = []
  end

  after do
    Sidekiq.send(:remove_const, :Client) # to avoid a warning
    Sidekiq::Client = @original_sidekiq
  end

  describe "authenticated as user with access" do
    before  { post("/v3/user/#{user.id}/sync", {}, headers) }
    example { expect(last_response.status).to be 202        }
    # example { expect(JSON.load(body)).to be ==        {
    #   "@type"      => "user",
    #   "@href"      => "/v3/user/#{user.id}",
    #   "id"         => user.id,
    #   "login"      => "svenfuchs",
    #   "name"       =>"Sven Fuchs",
    #   "github_id"  => user.github_id,
    #   "is_syncing" => user.is_syncing,
    #   "synced_at"  => user.synced_at
    # }}
  end
end