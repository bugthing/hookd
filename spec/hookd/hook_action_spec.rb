require "spec_helper"

RSpec.describe Hookd::HookAction do
  subject(:object) { described_class.new config }

  describe "#take_action" do
    subject { object.take_action }

    context "when config has an action of :print" do
      let(:config) do
        {action: "print", message: "test message"}
      end

      it "prints the message" do
        expect { subject }.to output("test message\n").to_stdout
      end
    end
  end
end
