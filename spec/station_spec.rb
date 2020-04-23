require 'station'

describe Station do

  subject { described_class.new(name: "Kings cross", zone: 1)}
  
  it 'has a name' do
    expect(subject.name).to eq "Kings cross"
  end

  it 'has a zone' do
    expect(subject.zone).to eq 1
  end

end