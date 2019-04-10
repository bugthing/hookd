require "spec_helper"

RSpec.describe Hookd::HookAction do
  subject(:object) { described_class.new match }

  let(:match) do
    instance_double Hookd::HookMatch, config: config,
                                      request_json: json
  end

  let(:config) {}
  let(:json) {}

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

    context "when config has an action of :cmd" do
      let(:config) do
        {action: "cmd", command: "echo 'hello'"}
      end

      it "runs the command" do
        # TODO - assert command has run in a better way
        #expect { subject }.to output("hello\n").to_stdout
        expect(subject).to eq "hello\n"
      end

      context "when command contains ERB templating" do
        let(:config) do
          {action: "cmd", command: 'echo <%= json["var"] %>'}
        end
        let(:json) { { "var" => "something" }}

        it "parsed the erb template and runs as a command" do
          # TODO - assert command has run in a better way
          expect(subject).to eq "something\n"
        end
      end

    end
  end
end
