require "test_helper"

class BoardPrinterTest < Minitest::Test
  def setup
    @board = Minesweeper::Board.new(4, 4, [2, 7, 8, 15])
    @game = Minesweeper::Game.new(@board)
    @game.formatter.show_bombs = 'show'
    @board_array = @game.formatter.format_board_with_emoji(@game.board, @game.icon_style)
    @board_printer = Minesweeper::BoardPrinter.new
  end

  def test_that_it_returns_a_string_to_output_to_the_board
    result = @board_printer.board_to_string(@board_array, @game.board)

    assert result.end_with?("+======+======+======+======+")
  end

  def test_that_it_returns_a_string_to_output_to_the_board_1
    result = @board_printer.board_to_string(@board_array, @game.board)

    assert_match /|  💣  |/, result
  end

  def test_that_it_prints_to_the_console
      out, _err = capture_io do
        @board_printer.print_board(@board_array, @game.board)
      end

      assert_match /|  💣  |/, out
  end
end
