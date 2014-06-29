require_relative 'simple_test'
describe SimpleTest do
  let(:input) { [] }
  let(:expected_output) { %w(1 2 3) }
  let(:wrong_output) { [] }
  let(:individual) { double }
  let(:ring_engine) { double }

  subject do
    described_class.new(ring_engine, input, expected_output)
      .passes?(individual)
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

