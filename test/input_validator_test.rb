require 'stringio'
require "test_helper"
require "io_test_helpers"

class InputValidatorTest < Minitest::Test
  include IoTestHelpers

  def setup
    @validator = Minesweeper::InputValidator
    @cli = Minesweeper::CLI.new
    @board = Minesweeper::Board.new(10,10)
    @mock_game = Minesweeper::MockGame.new(@board)
    @game = Minesweeper::Game.new(@board)
    @mock_cli = Minesweeper::MockCli.new
    @mock_io = { output: Minesweeper::MockOutput.new, input: Minesweeper::Input.new }
  end

  def test_that_it_can_check_if_emoji_type_input_has_correct_format
    assert @validator.emoji_type_has_correct_format('B')
    assert @validator.emoji_type_has_correct_format('b')
    assert @validator.emoji_type_has_correct_format('S')
    assert @validator.emoji_type_has_correct_format('s')
  end

  def test_that_it_can_check_if_entered_bomb_count_is_not_an_integer
    simulate_stdin("test") { @cli.get_player_entered_bomb_count(100, @mock_io) }
    assert "That is not a valid bomb count. Please try again.\n"
  end

  def test_that_it_can_check_if_entered_bomb_count_is_too_large
    assert_output "That is not a valid bomb count. Please try again.\n" do
      simulate_stdin("105") { @cli.get_player_entered_bomb_count(100, @mock_io) }
    end
  end

  def test_that_it_can_capture_a_board_size_from_the_player
    assert_output "You have selected a 10 x 10 board. Generating board.\n" do
      simulate_stdin("10") {@cli.get_player_entered_board_size(@mock_io) }
    end
  end

  def test_that_it_can_check_if_entered_board_size_is_not_an_integer
    simulate_stdin("test") { @cli.get_player_entered_board_size(@mock_io) }
    assert "That is not a valid row size. Please try again.\n"
  end

  def test_that_it_can_check_if_entered_board_size_is_too_large
    assert_output "That is not a valid row size. Please try again.\n" do
      simulate_stdin("35") { @cli.get_player_entered_board_size(@mock_io) }
    end
  end

  def test_that_it_can_check_if_the_coordinates_are_less_than_the_rowsize
    simulate_stdin("3,12") { @cli.get_player_input(@mock_game, @mock_io) }
    assert "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!\n"
  end

  def test_that_it_can_check_if_the_input_is_valid_1
    simulate_stdin("bad input") { @cli.get_player_input(@mock_game, @mock_io) }
    assert "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!\n"
  end

  def test_that_it_can_check_if_the_input_is_valid_2
    simulate_stdin("flag A,8") { @cli.get_player_input(@mock_game, @mock_io) }
    assert "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!\n"
  end

  def test_that_it_can_return_validated_coordinates
    input = "move 1,3"
    assert_output "You selected move 1,3. Placing your move.\n" do
      simulate_stdin() {@validator.return_coordinates_if_input_is_within_range(input, @game)}
    end
  end

  def test_that_it_can_return_the_validated_row_size
    input = "8"
    assert_output "You have selected a 8 x 8 board. Generating board.\n" do
      simulate_stdin() {@validator.return_row_size_if_input_is_within_range(input)}
    end
  end

  def test_that_it_can_return_the_validated_bomb_count
    input = "10"
    assert_output "You selected 10. Setting bombs!\n" do
      simulate_stdin() {@validator.return_bomb_count_if_input_is_within_range(input, 64)}
    end
  end
end
