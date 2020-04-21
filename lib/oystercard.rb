
class Oystercard
  attr_reader :balance, :journey_history, :entry_station, :exit_station

  LIMIT = 90
  MINIMUM_VALUE = 1

  def initialize
    @balance = 0
    @journey_history = []
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
  
  def touch_out(station)
    deduct(MINIMUM_VALUE)
    @entry_station = nil
    @in_journey = false
    @exit_station = station
    @journey_history << {:entry_station => @entry_station, :exit_station => @exit_station}
  end
  
end