require_relative 'stream_solver'
require 'ostruct'

describe StreamSolver do
  let(:individual) { double('individual') }
  let(:score) { 0 }
  let(:scores) { [OpenStruct.new(score:score, individual:individual)] }
  let(:scoreboard) { double('score_board', add_score: nil,
                                           scores: scores) }
  let(:test_set) { double('test_set', failed_test_count: score) }
  let(:bus) do
    double('bus', refill: nil, passengers: [individual])
  end
  subject { described_class.new test_set, bus, scoreboard }

  it 'adds scores to the scoreboard' do
    expect(scoreboard).to receive(:add_score).with(individual, score)
    subject.find_solution
  end

  it 'refills bus' do
    expect(bus).to receive(:refill)
    subject.find_solution
  end

  it 'passes scores to bus on refill' do
    expect(bus).to receive(:refill).with scores.map(&:individual)
    subject.find_solution
  end

end
