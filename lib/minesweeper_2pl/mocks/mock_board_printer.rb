module Minesweeper
    class MockBoardPrinter < BoardPrinter
  
      def set_input!(input)
        @input = input
      end
  
      def print_board(_board_array, _board, _io)
        print @input
      end
  
    end
  end