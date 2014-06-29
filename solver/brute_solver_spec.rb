require_relative 'brute_solver'

describe BruteSolver do
  let(:test_set) { double('test_set', :passes? => true) }
  let(:passing_individual) { 'passing_individual' }
  let(:failing_individual) { 'failing_individual' }
  let(:passengers) { [ failing_individual, passing_individual ] }
  let(:bus) do
    double(:passengers => passengers,
           :refill => nil )
  end
  subject { described_class.new(test_set, bus) }

  before do
    allow(test_set).to receive(:passes?).with(passing_individual) { true }
    allow(test_set).to receive(:passes?).with(failing_individual) { false }
  end

  context 'one failing + one passing passenger' do
    it 'returns passing individual' do
      expect(subject.find_solution).to eq passing_individual
    end
  end
end

