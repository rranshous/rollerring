require_relative 'genetic_bus'

describe GeneticBus do
  let(:individual) { double('individual') }
  let(:result_individual) { double('result_individual') }
  let(:birther) { double(grow: individual) }
  let(:mater) { double('mater') }
  let(:mutator) { double('mutator') }
  let(:max_population) { 2 }
  subject { described_class.new birther, mater, mutator, max_population }

  it 'accepts a list of individuals to seed refill from' do
    expect { subject.refill }.to raise_error(ArgumentError)
  end

  it 'bases new individual on seed individuals' do
    expect(mater).to receive(:mate).with(individual, individual)
                      .twice { result_individual }
    expect(mutator).to receive(:mutate).with(result_individual).twice
    subject.refill [individual, individual]
  end

  it 'fills passenger list from mated individuals' do
    allow(mater).to receive(:mate) { result_individual }
    allow(mutator).to receive(:mutate) { result_individual }
    subject.refill [individual, individual]
    expect(subject.passengers).to eq [result_individual, result_individual]
  end

end

