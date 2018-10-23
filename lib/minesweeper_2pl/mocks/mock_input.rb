module Minesweeper
  class MockInput < Input
    def initialize
      @count = 0
    end

    def reset_count
      @count = 0
    end

    def set_input!(*args)
      @inputs = []
      args.each do |arg|
        @inputs << arg
      end
      @inputs
    end

    def get_input
      result = @inputs[@count]
      @count += 1
      result
    end
  end
end