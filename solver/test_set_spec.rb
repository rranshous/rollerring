require_relative 'test_set'

describe TestSet do
  let(:passing_test) { instance_double("SimpleTest", :passes? => true) }
  let(:failing_test) { instance_double("SimpleTest", :passes? => false) }
  let(:individual) { double }
  let(:tests) { [ ] }
  subject { described_class.new tests }

  context 'passing tests' do
    let(:tests) { [ passing_test, passing_test ] }
    it 'passes tests' do
      expect(subject.passes?(individual)).to be true
    end
  end

  context 'one passing and one failing test' do
    let(:tests) { [ failing_test, passing_test ] }
    it 'fails tests' do
      expect(subject.passes?(individual)).to be false
    end

    it 'returns the number of failed tests' do
      expect(subject.failed_test_count(individual)).to eq 1
    end
  end

end
