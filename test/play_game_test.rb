require "test_helper"

class PlayGameTest < Minitest::Test
  def setup
    bomb_positions = [10, 11, 12, 13, 14]
    @mock_board = Minesweeper::Board.new(5, 5, bomb_positions)
    @mock_cli = Minesweeper::MockCli.new
    @mock_app = Minesweeper::App.new
    @test_io = { 
      output: Minesweeper::Output.new,
      input: 'test',
      board_formatter: Minesweeper::CliBoardFormatter.new,
      board_printer: Minesweeper::MockBoardPrinter.new
    }
    @mock_game = Minesweeper::Game.new(@mock_board, @test_io)
  end

  def test_play_game_runs_the_game_loop_and_places_moves
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_cli.reset_count
    @mock_cli.set_input!([2,2,'move'], nil)

    Minesweeper::PlayGame.new.run(@mock_game, @mock_cli, @test_io)

    assert(@mock_game.game_over)
  end

  def test_play_game_runs_the_game_loop_and_can_check_if_a_move_is_valid
    flags = [7,10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_cli.reset_count
    @mock_cli.set_input!([1,0,'move'], [2,2,'move'])

    out, _err = capture_io do
      Minesweeper::PlayGame.new.run(@mock_game, @mock_cli, @test_io)
    end

    assert_equal('That was not a valid move. Please try again.', out)
  end

  def test_play_game_runs_the_game_loop_and_places_moves_till_the_game_is_over
    @mock_cli.reset_count
    @mock_cli.set_input!([2,1,'move'], [2,2,'move'])

    Minesweeper::PlayGame.new.run(@mock_game, @mock_cli, @test_io)

    assert_equal('revealed', @mock_game.board.positions[8].status)
  end
end
