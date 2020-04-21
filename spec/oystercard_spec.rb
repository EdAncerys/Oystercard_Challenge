require 'oystercard'

describe Oystercard do

  let(:station) { double :Station}

  before(:each) { subject.top_up(Oystercard::MINIMUM_VALUE) }

  it '#top_up should be able to add to the balance' do
    expect(subject.balance).to eq Oystercard::MINIMUM_VALUE
  end

  it '#top_up should able to add to curent balnce' do
    expect { 2.times { subject.top_up(15) } }.to change{ subject.balance }.by(30)
  end

  it 'should have balance limit of 90' do
    message = "Balance limit reached: #{Oystercard::LIMIT}"
    expect { subject.top_up(Oystercard::LIMIT) }.to raise_error message
  end

  it 'should be able to #deduct from balance' do
    expect(subject.deduct(Oystercard::MINIMUM_VALUE)).to eq 0
  end

  it { is_expected.to respond_to :in_journey }

  it 'when card created #in_journey should be eq to false' do
    expect(subject.in_journey?).to eq false
  end

  it 'should change @in_journey to true when #touch_in' do
    subject.touch_in 'station'
    expect(subject.in_journey?).to eq true 
  end

  it 'should change @in_journey to false when #touch_out' do
    expect(subject.touch_out).to eq false
  end

  it 'should have a minimum of a 1£ when #touch_in' do 
    subject.deduct(Oystercard::MINIMUM_VALUE)
    message = "Balance bellow minimum"
    expect { subject.touch_in("station") }.to raise_error message
  end

  it 'should be able to charge for the journey' do 
    expect { subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUM_VALUE)
  end

  it 'should upon #touch_in remember station name' do
    expect((subject.touch_in station)).to eq station
  end

  it 'should set entry station to nil upon #touch_out' do
    subject.touch_in station
    subject.touch_out
    expect(subject.entry_station).to eq nil
  end

end