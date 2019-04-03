RSpec.describe Hookd::RackApp do
  subject(:app) { described_class.new }

  include Rack::Test::Methods

  describe "a github webhook request" do
    before do
      header "X-GitHub-Delivery", "72d3162e-cc78-11e3-81ab-4c9367dc0958"
      header "X-Hub-Signature", "sha1=f7cda6d42473f557054bab71c1735862b79d1016"
      header "X-GitHub-Event", "issues"
      header "CONTENT_TYPE", "application/json"
      post "/payload", json
    end

    let(:json) do
      <<~JSON
        {
          "action": "opened",
          "issue": {
            "url": "https://api.github.com/repos/octocat/Hello-World/issues/1347",
            "number": 1347,
          },
          "repository" : {
            "id": 1296269,
            "full_name": "octocat/Hello-World",
            "owner": {
              "login": "octocat",
              "id": 1,
            },
          },
          "sender": {
            "login": "octocat",
            "id": 1,
          }
        }
      JSON
    end

    it "processes the requests and responds accordingly" do
      expect(last_response).to be_ok
    end
  end
end
