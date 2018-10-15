module Minesweeper
  class MockGame < Game

    def set_input!(input)
      @input = input
    end

    def print_board
      print @input
    end

  end
end
