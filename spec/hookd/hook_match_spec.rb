require "spec_helper"

RSpec.describe Hookd::HookMatch do
  subject(:object) { described_class.new config }

  describe "#match" do
    subject { object.matches? request }

    context "when config is matching on a single header" do
      let(:config) do
        {header: {some_header: "headercontent"}}
      end

      context "when the request have a matching header" do
        let(:request) { make_request("payload", {"HTTP_SOME_HEADER" => "headercontent"}) }
        it { is_expected.to be true }
      end
      context "when the request does not have a matching header" do
        let(:request) { make_request("payload", {"HTTP_SOME_HEADER" => "notmatch"}) }
        it { is_expected.to be false }
      end
    end

    context "when config is matching multiple headers" do
      let(:config) do
        {header: {some_header: "headercontent", other_header: "morecontent"}}
      end
      context "when the request has all matching headers" do
        let(:request) { make_request("payload", {"HTTP_SOME_HEADER" => "headercontent", "OTHER_HEADER" => "morecontent"}) }
        it { is_expected.to be true }
      end
      context "when the request has 1 not matching header" do
        let(:request) { make_request("payload", {"HTTP_SOME_HEADER" => "headercontent", "OTHER_HEADER" => "notmatch"}) }
        it { is_expected.to be false }
      end
    end

    context "when config is matching the path" do
      let(:config) do
        {path: "/payload"}
      end
      context "when the request has a matching path" do
        let(:request) { make_request("payload") }
        it { is_expected.to be true }
      end
      context "when the request does not have a matching path" do
        let(:request) { make_request("loadpay") }
        it { is_expected.to be false}
      end
    end

    context "when config is matching the json" do
      let(:config) do
        {json: {some: "thing"}}
      end
      context "when the request has a matching json" do
        let(:request) { make_request("payload", {}, '{"attr": "", "some": "thing"}') }
        it { is_expected.to be true }
      end
      context "when the request does not have a matching path" do
        let(:request) { make_request("payload", {}, '{"attr": "", "some": "motmatch"}') }
        it { is_expected.to be false}
      end
    end
  end

  def make_request(path, headers = {}, body = nil)
    Rack::Request.new(
      Rack::MockRequest.env_for(
        "http://example.com/#{path}",
        {
          "REQUEST_METHOD" => "POST",
          :input => body,
        }.merge(headers),
      )
    )
  end
end
