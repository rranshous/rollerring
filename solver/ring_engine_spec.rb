require_relative 'ring_engine'

describe RingEngine do
  let(:individual) { [1] }
  let(:input) { double }
  let(:cycles) { 10 }
  subject { described_class.new(cycles) }

  it 'should create ring w/ passed individual' do
    expect(Ring).to receive(:new).with(individual) { double(run: nil) }
    subject.run individual, input
  end

  it 'should run the ring input' do
    expect_any_instance_of(Ring).to(
      receive(:run).with(0, kind_of(Integer), input) { }
    )
    subject.run individual, input
  end

  it 'should cycle the passed number of times' do
    expect_any_instance_of(Ring).to(
      receive(:run).with(0, cycles, input) { }
    )
    subject.run individual, input
  end
end

describe CachingRingEngine do
  let(:individual) { [1] }
  let(:input) { double }
  let(:cycles) { 10 }

  subject { described_class.new(cycles) }

  it 'does not rerun individuals' do
    expect(Ring).to receive(:new).with(individual).once { double(run: nil) }
    subject.run individual, input
    subject.run individual, input
  end

  it 'double runs result in the same output' do
    allow(Ring).to receive(:new).with(individual).once { double(run: 'output') }
    original_output = subject.run individual, input
    expect(original_output).to eq subject.run(individual, input)
  end
end
