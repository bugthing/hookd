require "spec_helper"

RSpec.describe Hookd::Configs do
  subject(:object) { described_class.new }

  describe "#configs" do
    subject { object.config_files }

    it "lists all the yaml configs" do
      expect(subject).to contain_exactly(
        a_string_ending_with("github.yml"),
        a_string_ending_with("gitlab.yml")
      )
    end
  end

  describe "#hooks" do
    subject { object.hooks }

    it "find all hook matching config in all config files" do
      expect(subject).to match a_collection_including(
        a_kind_of(Hookd::HookMatch),
        a_kind_of(Hookd::HookMatch),
        a_kind_of(Hookd::HookMatch)
      )
    end
  end
end
