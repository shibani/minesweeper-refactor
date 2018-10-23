module Minesweeper
  class MockOutput < Output
    def display(msg)
      return msg
    end
  end
end