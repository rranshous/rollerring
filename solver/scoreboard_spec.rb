require_relative 'scoreboard'

describe Scoreboard do
  let(:individual) { double }
  let(:max_size) { 2 }
  subject { described_class.new max_size }

  context 'scores added best to worst' do
    before do
      subject.add_score(individual, 1)
      subject.add_score(individual, 2)
    end

    it 'does not collect worse scores' do
      expect(subject.scores).to eq(
        [OpenStruct.new(score: 1, individual: individual)])
    end
  end

  context 'scores added worst to best' do
    before do
      subject.add_score(individual, 2)
      subject.add_score(individual, 1)
    end

    it 'collects scores' do
      expect(subject.scores).to eq([
        OpenStruct.new(score: 1, individual: individual),
        OpenStruct.new(score: 2, individual: individual)])
    end

    context 'more scores added than max allows' do
      before do
        subject.add_score(individual, 3)
      end

      it 'limits itself to best scores' do
        expect(subject.scores.length).to be 2
      end
    end
  end
end
