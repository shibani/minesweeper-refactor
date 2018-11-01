require 'stringio'
require "test_helper"
require "io_test_helpers"

class InputValidatorTest < Minitest::Test
  include IoTestHelpers

  def setup
    @validator = Minesweeper::InputValidator
    @cli = Minesweeper::CLI.new
    @board = Minesweeper::Board.new(10,10)
    @mock_cli = Minesweeper::MockCli.new
    @test_io = { output: Minesweeper::Output.new, input: Minesweeper::Input.new }
    @mock_game = Minesweeper::Game.new(@board, @test_io)
    @game = Minesweeper::Game.new(@board, @test_io)
  end

  def test_that_it_can_check_if_emoji_type_input_has_correct_format
    assert @validator.emoji_type_has_correct_format('B')
    assert @validator.emoji_type_has_correct_format('b')
    assert @validator.emoji_type_has_correct_format('S')
    assert @validator.emoji_type_has_correct_format('s')
  end

  def test_that_it_can_check_if_entered_bomb_count_is_not_an_integer
    assert_output "That is not a valid bomb count. Please try again." do
      simulate_stdin("test") { @cli.get_player_entered_bomb_count(100, @test_io) }
    end
  end

  def test_that_it_can_check_if_entered_bomb_count_is_too_large
    assert_output "That is not a valid bomb count. Please try again." do
      simulate_stdin("105") { @cli.get_player_entered_bomb_count(100, @test_io) }
    end
  end

  def test_that_it_can_capture_a_board_size_from_the_player
    assert_output "You have selected a 10 x 10 board. Generating board." do
      simulate_stdin("10") {@cli.get_player_entered_board_size(@test_io) }
    end
  end

  def test_that_it_can_check_if_entered_board_size_is_not_an_integer
    assert_output "That is not a valid row size. Please try again." do
      simulate_stdin("test") { @cli.get_player_entered_board_size(@test_io) }
    end
  end

  def test_that_it_can_check_if_entered_board_size_is_too_large
    assert_output "That is not a valid row size. Please try again." do
      simulate_stdin("35") { @cli.get_player_entered_board_size(@test_io) }
    end
  end

  def test_that_it_can_check_if_the_coordinates_are_less_than_the_rowsize
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("3,12") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_check_if_the_input_is_valid_1
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("bad input") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_check_if_the_input_is_valid_2
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("flag A,8") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_return_validated_coordinates
    input = "move 1,3"
    assert_output "You selected move 1,3. Placing your move." do
      simulate_stdin() {@validator.return_coordinates_if_input_is_within_range(input, @game, @test_io)}
    end
  end

  def test_that_it_can_return_the_validated_row_size
    input = "8"
    assert_output "You have selected a 8 x 8 board. Generating board." do
      simulate_stdin() {@validator.return_row_size_if_input_is_within_range(input, @test_io)}
    end
  end

  def test_that_it_can_return_the_validated_bomb_count
    input = "10"
    assert_output "You selected 10. Setting bombs!" do
      simulate_stdin() {@validator.return_bomb_count_if_input_is_within_range(input, 64, @test_io)}
    end
  end
end
