require_relative 'scorer'

describe Scorer do
  let(:output) { [1] }
  let(:expected) { [] }
  subject { described_class.score expected, output }

  context 'output is expected' do
    let(:expected) { [1] }
    it { should eq 5 }
  end

  context 'output has elements in wrong locations' do
    let(:output) { [2,1] }
    let(:expected) { [1,2] }
    it { should eq 2 }
  end

  context 'output has nothing in common' do
    let(:expected) { [9] }
    it { should eq 0 }
  end

  it 'calculates max score for solutions' do
    expect(described_class.max_score([1,2,3])).to eq 15
  end
end

