require_relative 'scorer'

describe Scorer do
  let(:output) { [1,2,3,1,2,3] }
  let(:expected) { [1,2,3] }
  subject { described_class.score expected, output }

  context 'output is expected' do
    let(:output) { expected }
    it { should eq 0 }
  end

  context 'output shares no matches, but is same length' do
    let(:output) { [4,4,4] }
    it { should eq 3 }
  end

  context 'output starts the same but is longer' do
    let(:output) { [1,2,3] * 10 }
    it { should eq 27 }
  end

  context 'output has zero length' do
    let(:output) { [] }
    it { should eq 999999 }
  end
end

