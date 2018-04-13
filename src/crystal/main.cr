lib LibCrystalMain
  @[Raises]
  fun __crystal_main(argc : Int32, argv : UInt8**)
end

module Crystal
  @@stdin_is_blocking = false
  @@stdout_is_blocking = false
  @@stderr_is_blocking = false

  def self.main(&block)
    GC.init

    remember_blocking_state

    status =
      begin
        yield
        0
      rescue ex
        1
      end

    AtExitHandlers.run status
    ex.inspect_with_backtrace STDERR if ex
    STDOUT.flush
    STDERR.flush

    restore_blocking_state

    status
  end

  def self.main(argc : Int32, argv : UInt8**)
    main do
      main_user_code(argc, argv)
    end
  end

  def self.main_user_code(argc : Int32, argv : UInt8**)
    LibCrystalMain.__crystal_main(argc, argv)
  end

  def self.remember_blocking_state
    @@stdin_is_blocking = IO::FileDescriptor.fcntl(0, LibC::F_GETFL) & LibC::O_NONBLOCK == 0
    @@stdout_is_blocking = IO::FileDescriptor.fcntl(1, LibC::F_GETFL) & LibC::O_NONBLOCK == 0
    @@stderr_is_blocking = IO::FileDescriptor.fcntl(2, LibC::F_GETFL) & LibC::O_NONBLOCK == 0
  end

  def self.restore_blocking_state
    STDIN.blocking = @@stdin_is_blocking
    STDOUT.blocking = @@stdout_is_blocking
    STDERR.blocking = @@stderr_is_blocking
  end
end

fun main = crystal_library_init(argc : Int32, argv : UInt8**) : Int32
  Crystal.main(argc, argv)
end
