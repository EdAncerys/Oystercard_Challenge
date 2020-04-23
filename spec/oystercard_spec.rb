require 'oystercard'

describe Oystercard do

  let(:entry_station){ double :station } 
  let(:exit_station){ double :station }
  let(:trip){ {entry_station: entry_station, exit_station: exit_station} }

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
    expect { subject.touch_out exit_station }.to change{ subject.balance }.by( -Oystercard::MINIMUM_VALUE)
  end

  it { is_expected.to respond_to :in_journey? }

  it 'when card created #in_journey should be eq to false' do
    expect(subject.in_journey?).to eq false
  end
  
  it 'should be able to charge for the journey' do 
    expect { subject.touch_out exit_station }.to change{ subject.balance }.by(-Oystercard::MINIMUM_VALUE)
  end
  
  it 'should have journey_history emty upon start' do
    expect(subject.journey_history.empty?).to eq true
  end
  
  it 'stores journey history' do 
    subject.top_up(10)      
    subject.touch_in(entry_station)      
    subject.touch_out(exit_station)      
    expect(subject.journey_history).to include trip    
  end
  
  describe '#touch_in' do

    it 'should have a minimum of a 1£ when #touch_in' do 
      subject.touch_in entry_station
      expect(subject.balance).to eq Oystercard::MINIMUM_VALUE
    end
    it 'should change @in_journey to true when #touch_in' do
      subject.touch_in entry_station
      expect(subject.in_journey?).to eq true 
    end
    it 'should upon #touch_in remember station name' do
      expect((subject.touch_in entry_station)).to eq entry_station
    end
  end
  
  describe '#touch_out' do
    before do 
      subject.touch_in entry_station
      subject.touch_out exit_station
    end

    it 'should set entry station to nil upon #touch_out' do
      expect(subject.entry_station).to eq nil
    end
    it 'should save trip upon #touch_out and remember history' do
      expect(subject.journey_history.empty?).to eq false
    end
    it 'shout have journey_history after a travel' do
      expect(subject.journey_history.empty?).to eq false
    end
    it 'should change @in_journey to false when #touch_out' do
      expect(subject.in_journey?).to eq false
    end
  end
  

end
