class Counter
  getter actual : Int32

  def initialize(@actual : Int32 = 0)
  end

  def incr(by = 1)
    @actual = @actual + by
  end

  def decr(by = 1)
    @actual = @actual - by
  end
end
