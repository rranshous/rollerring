require_relative 'simple_test'

describe SimpleTest do
  let(:input) { [] }
  let(:expected_output) { %w(1 2 3) }
  let(:wrong_output) { [] }
  let(:individual) { double() }
  let(:can_output) { true }
  let(:ring_engine) { double('ringengine') }
  let(:scorer) { double('scorer') }
  let(:instance) do
    described_class.new(ring_engine, input, expected_output, scorer)
  end

  before do
    allow(individual).to receive(:include?).with('output') { can_output }
  end

  context '#score' do

    before do
      allow(ring_engine).to receive(:run).with(individual, anything) do
        expected_output
      end
    end

    it 'returns -1 * scorers score' do
      allow(scorer).to receive(:score).with(expected_output, expected_output) { 10 }
      expect(instance.score(individual)).to eq -10
    end
  end

  context '#passes' do
    subject do
      instance.passes?(individual)
    end

    context 'a passing individual' do
      before do
        allow(ring_engine).to receive(:run) { expected_output }
      end
      it{ should == true }
    end

    context 'a non passing individual' do
      before do
        allow(ring_engine).to receive(:run) { wrong_output }
      end
      it{ should == false }
    end
  end
end

