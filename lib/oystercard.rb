
class Oystercard
  attr_reader :balance, :in_journey, :entry_station

  LIMIT = 90
  MINIMUM_VALUE = 1

  def initialize
    @balance = 0
  end

  def top_up(value)
    fail "Balance limit reached: #{LIMIT}" if value + balance > LIMIT

    @balance += value
  end

  def deduct(value)
    @balance -= value
  end

  def in_journey?
    !!entry_station
  end
  
  def touch_in(station)
    fail "Balance bellow minimum" if balance < MINIMUM_VALUE

    @entry_station = station
  end
  
  def touch_out
    deduct(MINIMUM_VALUE)
    @entry_station = nil
    @in_journey = false
  end
  
end