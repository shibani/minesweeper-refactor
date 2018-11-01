require "test_helper"

class SetupGameTest < Minitest::Test
  def setup
    @messages = Minesweeper::Messages.new
    @validator = Minesweeper::InputValidator.new(@messages)
    bomb_positions = [10, 11, 12, 13, 14]
    @test_board = Minesweeper::Board.new(5, 5, bomb_positions)
    @mock_cli = Minesweeper::MockCli.new(@messages, @validator)
    @test_app = Minesweeper::App.new
    @test_io = { 
      output: Minesweeper::Output.new, 
      input: 'test',
      board_formatter: Minesweeper::CliBoardFormatter.new,
      board_printer: Minesweeper::MockBoardPrinter.new
    }
  end

  def test_that_run_can_setup_and_return_a_new_game
    @mock_output = Minesweeper::MockOutput.new
    @test_setup_game = Minesweeper::SetupGame.new
    result = @test_setup_game.run(@mock_cli, @test_io)

    assert_instance_of(Minesweeper::Game, result)
  end

  def test_that_initialize_can_set_the_formatter_type_and_rows_and_bomb_count
    @test_setup_game = Minesweeper::SetupGame.new
    game = @test_setup_game.run(@mock_cli, @test_io)

    assert_equal(10, game.board.row_size)
    assert_equal(70, game.board.bomb_count)
    assert_instance_of(Minesweeper::CliBoardFormatter, game.formatter)
  end
end