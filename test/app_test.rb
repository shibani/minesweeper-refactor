require "test_helper"

class AppTest < Minitest::Test
  def setup
    @messages = Minesweeper::Messages.new
    @validator = Minesweeper::InputValidator.new(@messages)
    bomb_positions = [10, 11, 12, 13, 14]
    @mock_board = Minesweeper::Board.new(5, 5, bomb_positions)
    @mock_cli = Minesweeper::MockCli.new(@messages, @validator)
    @mock_app = Minesweeper::App.new
    @test_io = { 
      output: Minesweeper::Output.new, 
      input: 'test',
      board_formatter: Minesweeper::CliBoardFormatter.new,
      board_printer: Minesweeper::MockBoardPrinter.new
    }
    @mock_game = Minesweeper::Game.new(@mock_board, @test_io)
  end

  def test_play_game_can_check_if_the_game_is_not_over
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }

    @mock_cli.reset_count
    @mock_cli.set_input!([0,0,'move'], nil)

    refute(@mock_game.game_over)
  end

  def test_end_game_can_check_if_the_game_is_won
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_game.game_over = true

    assert_equal('win', @mock_game.check_win_or_loss)
  end
end
