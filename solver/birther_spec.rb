require_relative 'birther'

describe Birther do
  let(:length) { 10 }
  subject { described_class.new(length) }

  it 'grows a new individual' do
    expect(subject.grow).to be_kind_of(Array)
  end

  it 'takes individual length' do
    expect(RingGen).to receive(:random).with(10)
    subject.grow
  end
end

