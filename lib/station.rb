class Station
  attr_reader :name, :zone
  def initialize(name: "", zone: 0)
    @name = name
    @zone = zone
  end
end