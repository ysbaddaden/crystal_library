lib LibCrystalMain
  @[Raises]
  fun __crystal_main(argc : Int32, argv : UInt8**)
end

macro define_library_init
  # :nodoc:
  fun crystal_library_init : Void
    GC.init
    {{yield LibCrystalMain.__crystal_main(0, nil)}}
  end
end

define_library_init do |main|
  {{main}}
end
