require_relative 'genetic_bus'

describe GeneticBus do
  let(:individual) { double('individual') }
  let(:result_individual) { double('result_individual') }
  let(:random_individual) { double('random_individual') }
  let(:birther) { double(grow: random_individual) }
  let(:mater) { double(mate: result_individual) }
  let(:mutator) { double(mutate: result_individual) }
  let(:max_population) { 2 }
  subject { described_class.new birther, mater, mutator, max_population }

  it 'accepts a list of individuals to seed refill from' do
    expect { subject.refill }.to raise_error(ArgumentError)
  end

  it 'bases new individual on seed individuals' do
    expect(mater).to receive(:mate)
      .with(individual, individual) { result_individual }
    expect(mutator).to receive(:mutate).with(result_individual)
    subject.refill [individual, individual]
  end

  it 'fills passenger list from mated individuals' do
    allow(mater).to receive(:mate) { result_individual }
    allow(mutator).to receive(:mutate) { result_individual }
    subject.refill [individual, individual]
    expect(subject.passengers).to include(result_individual)
  end

  describe "large population" do
    let(:max_population) { 200 }

    it 'fills 10% of the passengers with random individuals' do
      expect(birther).to receive(:grow).exactly(20).times
      subject.refill [individual, individual]
    end
  end

end

