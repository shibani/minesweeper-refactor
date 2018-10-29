require "test_helper"

class BoardPrinterTest < Minitest::Test
  def setup
    @board = Minesweeper::Board.new(4, 4, [2, 7, 8, 15])
    @board_printer = Minesweeper::BoardPrinter.new
    @test_io = {
      output: Minesweeper::Output.new, 
      input: Minesweeper::Input.new,
      board_printer: Minesweeper::BoardPrinter.new,
      board_formatter: Minesweeper::CliBoardFormatter.new
    }
    @game = Minesweeper::Game.new(@board, @test_io)
  end

  def test_that_it_returns_a_string_to_output_to_the_board
    @board_array = @game.formatter.format_board_with_emoji(@game.board, @game.icon_style)
    @game.formatter.show_bombs = 'show'
    result = @board_printer.board_to_string(@board_array, @game.board)

    assert result.end_with?("+======+======+======+======+")
  end

  def test_that_it_returns_a_string_to_output_to_the_board_1
    @board_array = @game.formatter.format_board_with_emoji(@game.board, @game.icon_style)
    @game.formatter.show_bombs = 'show'
    result = @board_printer.board_to_string(@board_array, @game.board)

    assert_match /|  💣  |/, result
  end

  def test_that_it_prints_to_the_console
    @board_array = @game.formatter.format_board_with_emoji(@game.board, @game.icon_style)
    @game.formatter.show_bombs = 'show'
    out, _err = capture_io do
      @board_printer.print_board(@board_array, @game.board, @test_io)
    end

    assert_match /|  💣  |/, out
  end
end
