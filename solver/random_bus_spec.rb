require_relative 'random_bus'

describe RandomBus do
  let(:max_population) { 10 }
  let(:random_individual) { double }
  let(:birther) { double(grow: random_individual) }
  subject { described_class.new birther, max_population }

  it 'refills itself with new passengers' do
    expect(birther).to receive(:grow).exactly(10).times { random_individual }
    subject.refill
  end

  it 'gives list of current passengers' do
    subject.refill
    expect(subject.passengers).to eq([ random_individual ] * max_population)
  end
end

