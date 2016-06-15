require "./counter"

fun counter_new(actual : LibC::Int) : Void*
  counter = Counter.new(actual)
  Box.box(counter)
end

fun counter_free(obj : Void*) : Void
  GC.free(obj)
end

fun counter_actual(obj : Void*) : LibC::Int
  counter = Box(Counter).unbox(obj)
  counter.actual
end

fun counter_incr(obj : Void*, by : LibC::Int) : LibC::Int
  counter = Box(Counter).unbox(obj)
  counter.incr(by)
end

fun counter_decr(obj : Void*, by : LibC::Int) : LibC::Int
  counter = Box(Counter).unbox(obj)
  counter.decr(by)
end
