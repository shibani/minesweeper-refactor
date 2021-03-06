require 'stringio'
require 'test_helper'
require 'io_test_helpers'

class CliTest < Minitest::Test
  include IoTestHelpers

  def setup
    @messages = Minesweeper::Messages.new
    @validator = Minesweeper::InputValidator.new(@messages)
    @cli = Minesweeper::CLI.new(@messages, @validator)
    @board = Minesweeper::Board.new(10,0)
    @mock_cli = Minesweeper::MockCli.new(@messages, @validator)
    @mock_io = { output: Minesweeper::MockOutput.new, input: Minesweeper::Input.new }
    @test_io = { 
      output: Minesweeper::Output.new, 
      input: Minesweeper::Input.new, 
      board_formatter: Minesweeper::CliBoardFormatter.new, 
      board_printer: Minesweeper::BoardPrinter.new }
    @mock_game = Minesweeper::Game.new(@board, @test_io)
  end

  def test_that_it_has_a_cli_class
    refute_nil @cli
  end

  def test_that_it_can_write_to_the_console
    out, _err = capture_io do
      @cli.print("welcome to minesweeper\n", @test_io)
    end
    assert_equal("welcome to minesweeper\n", out)
  end

  def test_that_it_has_a_print_method
    assert @cli.respond_to?(:print)
  end

  def test_that_the_start_method_returns_a_hash_for_the_game_config
    io = StringIO.new
    io.puts 's'
    io.puts '10'
    io.puts '70'
    io.rewind
    $stdin = io

    result = @mock_cli.start(@mock_io)
    $stdin = STDIN

    assert_equal({ formatter: 'S', row_size: 10, bomb_count: 70 }, result)
  end

  def test_that_it_can_get_the_emoji_type_from_the_player
    assert_output "You selected B for bombs.\n" do
      simulate_stdin('b') { @cli.get_emoji_type }
    end
  end

  def test_that_it_can_get_the_emoji_type_from_the_player
    assert_output "You selected S, prepare for a surprise!\n" do
      simulate_stdin('s') { @cli.get_emoji_type(@test_io) }
    end
  end

  def test_that_it_can_return_a_message_if_emoji_input_is_invalid
    simulate_stdin('y') { @cli.get_emoji_type(@mock_io) }
    assert "That was not a valid choice. Please try again.\n"
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

  def test_that_it_returns_the_board_size_if_valid
    io = StringIO.new
    io.puts "16"
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_entered_board_size(@test_io)
    end
    $stdin = STDIN

    assert_equal('You have selected a 16 x 16 board. Generating board.', out)
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

  def test_that_it_can_capture_a_bomb_count_from_the_player
    assert_output 'You selected 75. Setting bombs!' do
      simulate_stdin('75') { @cli.get_player_entered_bomb_count(100, @test_io) }
    end
  end

  def test_that_it_returns_the_bomb_count_if_valid
    io = StringIO.new
    io.puts '70'
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_entered_bomb_count(100, @test_io)
    end
    $stdin = STDIN

    assert_equal('You selected 70. Setting bombs!', out)
  end

  def test_that_it_can_get_and_set_the_board_size_and_bomb_count
    io = StringIO.new
    io.puts '10'
    io.puts '70'
    io.rewind
    $stdin = io

    result = @mock_cli.get_player_params
    $stdin = STDIN

    assert_equal([10,70], result)
  end

  def test_that_it_can_check_if_the_coordinates_are_less_than_the_rowsize
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("3,12") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_check_if_move_input_is_valid_1
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("bad input") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_check_if_move_input_is_valid_2
    assert_output "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!" do
      simulate_stdin("flag A,8") { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_capture_move_input_from_the_player_1
    assert_output 'You selected move 3,9. Placing your move.' do
      simulate_stdin('move 3,9') { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_can_capture_move_input_from_the_player_2
    assert_output 'You selected flag 9,0. Placing your flag.' do
      simulate_stdin('flag 9,0') { @cli.get_player_input(@mock_game, @test_io) }
    end
  end

  def test_that_it_returns_an_array_if_input_is_valid
    io = StringIO.new
    io.puts 'flag 5,6'
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_input(@mock_game, @test_io)
    end
    $stdin = STDIN

    assert_equal('You selected flag 5,6. Placing your flag.', out)
  end

  def test_that_it_can_get_a_player_move
    io = StringIO.new
    io.puts 'move 5,6'
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_move(@mock_game, @test_io)
    end
    $stdin = STDIN

    assert_includes(out, 'You selected move 5,6. Placing your move.')
  end

  def test_that_it_can_return_a_string_if_invalid_move
    result = @cli.invalid_move(@mock_io) 

    assert_equal('That was not a valid move. Please try again.', result)
  end

  def test_that_it_can_return_the_game_over_message
    string = "\nGame over! You win!\n"

    out, _err = capture_io do
      @cli.build_game_over_message('win', @test_io)
    end
    $stdin = STDIN

    assert_equal(string, out)
  end

  def test_that_it_can_print_the_board
    bomb_positions = [10, 11, 12, 13, 14]
    board = Minesweeper::Board.new(5, 5, bomb_positions)
    icon_style = Minesweeper::BombEmoji.new
    game = Minesweeper::Game.new(board, @test_io, icon_style)

    out, _err = capture_io do
      @cli.print_board(game, @test_io)
    end
    $stdin = STDIN

    expected = "\n         0      1      2      3      4  \n     +======+======+======+======+======+\n   0 |      |      |      |      |      |\n     +======+======+======+======+======+"

    assert_includes(out, expected)
  end
end
