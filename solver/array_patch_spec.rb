require_relative 'array_patch'

describe Array do
  let(:array) { [1,2,3] }
  let(:other) { [] }
  subject { array.send(:<=>, other) }

  context 'comparitor is the same' do
    let(:other) { [1,2,3] }
    it { should eq 0 }
  end

  context 'comparitor has lower second el' do
    let(:other) { [1,1,3] }
    it { should eq 1 }
  end

  context 'comparitor has higher second el' do
    let(:other) { [1,3,3] }
    it { should eq -1 }
  end
end
