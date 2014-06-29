require_relative 'mater'
require 'pry'

describe Mater do
  let(:individual1) { [1,2,3,4,5] }
  let(:individual2) { [6,7,8,9,0] }
  subject { described_class }
  it 'takes two individuals' do
    expect{ subject.mate(individual1, individual2) }.not_to raise_error
  end

  it 'returns a new individual' do
    expect(subject.mate(individual1, individual2)).to be_kind_of(Array)
  end

  it 'creates new individual mostly from parts of existing individuals' do
    result = subject.mate(individual1, individual2)
    combined_parents = individual1 + individual2
    overlap = result.select {|e| combined_parents.include?(e) }
    percent_overlap = overlap.length == 0 ? 0 : overlap.length.to_f / result.length
    expect(percent_overlap).to be > 0.90
  end
end
