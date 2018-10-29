require "test_helper"

class AppTest < Minitest::Test
  def setup
    bomb_positions = [10, 11, 12, 13, 14]
    @mock_board = Minesweeper::Board.new(5, 5, bomb_positions)
    @mock_cli = Minesweeper::MockCli.new
    @mock_app = Minesweeper::App.new
    @test_io = { 
      output: Minesweeper::Output.new, 
      input: 'test',
      board_formatter: Minesweeper::BoardFormatter.new,
      board_printer: Minesweeper::MockBoardPrinter.new
    }
    @mock_game = Minesweeper::MockGame.new(@mock_board, @test_io)
  end

  def test_that_app_can_setup_and_return_a_new_game
    @mock_output = Minesweeper::MockOutput.new
    result = @mock_app.setup_game(@mock_cli, @test_io) 

    assert_instance_of(Minesweeper::Game, result)
  end

  def test_that_initialize_can_get_player_input_and_set_the_formatter_type_and_rows_and_bomb_count
    @cli = Minesweeper::MockCli.new
    @board = Minesweeper::Board.new(10,7)
    @mock_game = Minesweeper::Game.new(@board, {})

    assert_equal(10, @mock_game.board.row_size)
    assert_equal(7, @mock_game.board.bomb_count)
  end

  def test_play_game_can_check_if_the_game_is_not_over
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }

    refute(@mock_game.game_over)
  end

  def test_play_game_runs_the_game_loop_and_places_moves
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_cli.reset_count
    @mock_cli.set_input!([2,2,'move'], nil)

    @mock_app.play_game(@mock_game, @mock_cli, @test_io)

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
      @mock_app.play_game(@mock_game, @mock_cli, @test_io)
    end

    assert_equal('That was not a valid move. Please try again.', out)
  end

  def test_play_game_runs_the_game_loop_and_places_moves_till_the_game_is_over
    @mock_cli.reset_count
    @mock_cli.set_input!([2,1,'move'], [2,2,'move'])

    @mock_app.play_game(@mock_game, @mock_cli, @test_io)

    assert_equal('revealed', @mock_game.board.positions[8].status)
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

  def test_end_game_can_check_if_the_game_is_lost
    @mock_game.game_over = true

    assert_equal('lose', @mock_game.check_win_or_loss)
  end

  def test_end_game_can_check_if_game_is_won_and_outputs_a_message_accordingly
    flags = [10,11,12,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_game.game_over = true

    out, _err = capture_io do
      @mock_app.end_game(@mock_game, @mock_cli, @test_io)
    end

    assert_equal("\nGame over! You win!\n", out)
  end

  def test_end_game_can_check_if_game_is_lost_and_outputs_a_message_accordingly
    flags = [10,11,13,14]
    flags.each { |fl| @mock_game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,12,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @mock_game.board_positions[el].revealed_status }
    @mock_game.game_over = true

    out, _err = capture_io do
      @mock_app.end_game(@mock_game, @mock_cli, @test_io)
    end

    assert_equal("\nGame over! You lose.\n", out)
  end

end
