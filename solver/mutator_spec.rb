require_relative 'mutator'
require 'pry'

describe Mutator do
  let(:individual) { 0.upto(100).to_a }
  subject { described_class }

  it 'changes the individual slightly' do
    result = subject.mutate(individual)
    overlap = result.select {|e| individual.include?(e) }
    percent_overlap = overlap.length == 0 ? 0 : overlap.length.to_f / result.length
    expect(percent_overlap).to be > 0.90
    expect(percent_overlap).to be < 1.0
  end

end
