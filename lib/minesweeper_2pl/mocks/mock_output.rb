module Minesweeper
  class MockOutput < Output
    def display(_msg)
      nil
    end
  end
end