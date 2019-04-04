RSpec.describe Hookd::RackApp do
  subject(:app) { described_class.new }

  include Rack::Test::Methods

  context "when a github webhook received" do
    subject { post "/payload", json }

    before { headers.each_pair { |k, v| header k, v } }

    let(:headers) { base_headers }
    let(:base_headers) do
      {"CONTENT_TYPE" => "application/json",
       "X-GitHub-Delivery" => "72d3162e-cc78-11e3-81ab-4c9367dc0958",
       "X-GitHub-Event" => "pull_request",}
    end
    let(:json) do
      <<~JSON
        {
          "action": "opened"
        }
      JSON
    end

    it "successfully processes the request" do
      subject
      expect(last_response).to be_ok
    end

    context "when configured with a secret" do
      around do |example|
        Hookd.configure { |cfg| cfg.secret = secret }
        example.run
        Hookd.configure { |cfg| cfg.secret = nil }
      end
      let(:secret) { "incorrect" }

      it "successfully processes the request" do
        subject
        expect(last_response).to be_ok
      end

      context "when signature included in headers" do
        let(:headers) do
          base_headers.merge "X-Hub-Signature" => "sha1=9767cc6f7dcd3c13f6f2248b2f32ff971fd6df2c"
        end

        it "fails the requests with a 401" do
          subject
          expect(last_response).to be_unauthorized
        end

        context "when the secret is correct" do
          let(:secret) { "correct" }

          it "successfully processes the request" do
            subject
            expect(last_response).to be_ok
          end
        end
      end
    end
  end
end
