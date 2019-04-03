RSpec.describe Hookd do
  describe '::configure' do
    subject do
      described_class.configure do |config|
        config.something = 'smells'
      end
    end

    it 'can be used for configuration' do
      subject

      expect(described_class.config).to have_attributes(something: 'smells')
    end
  end

  describe '::rack_app' do
    subject { described_class.rack_app }

    it { is_expected.to be_an_instance_of(Hookd::RackApp) }
  end
end
