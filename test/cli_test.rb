require 'stringio'
require "test_helper"
require "io_test_helpers"

class CliTest < Minitest::Test
  include IoTestHelpers

  def setup
    @cli = Minesweeper::CLI.new
    @board = Minesweeper::Board.new(10,0)
    @mock_game = Minesweeper::MockGame.new(@board)
    @mock_cli = Minesweeper::MockCli.new
  end

  def test_that_it_has_a_cli_class
    refute_nil @cli
  end

  def test_that_it_can_write_to_the_console
    out, _err = capture_io do
      @cli.print("welcome to minesweeper\n")
    end
    assert_equal("welcome to minesweeper\n", out)
  end

  def test_that_it_has_a_print_method
    assert @cli.respond_to?(:print)
  end

  def test_that_it_can_get_the_emoji_type_from_the_player
    assert_output "You selected B for bombs.\n" do
      simulate_stdin("b") { @cli.get_emoji_type }
    end
  end

  def test_that_it_can_get_the_emoji_type_from_the_player
    mock_io = {
      output: "test",
      input: "test"
    }
    assert_output "You selected S, prepare for a surprise!\n" do
      simulate_stdin("s") { @cli.get_emoji_type(mock_io) }
    end
  end

  def test_that_it_can_return_message_if_input_is_invalid
    mock_io = {
      output: Minesweeper::MockOutput.new,
      input: "test"
    }
    simulate_stdin("y") { @cli.get_emoji_type(mock_io) }
    assert "That was not a valid choice. Please try again.\n"
  end

  def test_that_it_can_capture_input_from_the_player_1
    mock_io = {
      output: "test",
      input: "test"
    }
    assert_output "You selected move 3,9. Placing your move.\n" do
      simulate_stdin("move 3,9") { @cli.get_player_input(@mock_game, mock_io) }
    end
  end

  def test_that_it_can_capture_input_from_the_player_2
    mock_io = {
      output: "test",
      input: "test"
    }
    assert_output "You selected flag 9,0. Placing your flag.\n" do
      simulate_stdin("flag 9,0") { @cli.get_player_input(@mock_game, mock_io) }
    end
  end

  def test_that_it_returns_an_array_if_input_is_valid
    mock_io = {
      output: "test",
      input: "test"
    }
    io = StringIO.new
    io.puts "flag 5,6"
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_input(@mock_game, mock_io)
    end
    $stdin = STDIN

    assert_equal("You selected flag 5,6. Placing your flag.\n", out)
  end

  def test_that_it_returns_the_board_size_if_valid
    mock_io = {
      output: "test",
      input: "test"
    }
    io = StringIO.new
    io.puts "16"
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_entered_board_size(mock_io)
    end
    $stdin = STDIN

    assert_equal("You have selected a 16 x 16 board. Generating board.\n", out)
  end

  def test_that_it_can_capture_a_bomb_count_from_the_player
    assert_output "You selected 75. Setting bombs!\n" do
      simulate_stdin("75") { @cli.get_player_entered_bomb_count(100) }
    end
  end

  def test_that_it_returns_the_bomb_count_if_valid
    io = StringIO.new
    io.puts "70"
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_player_entered_bomb_count(100)
    end
    $stdin = STDIN

    assert_equal("You selected 70. Setting bombs!\n", out)
  end

  def test_that_it_can_get_and_set_the_board_size_and_bomb_count
    io = StringIO.new
    io.puts "10"
    io.puts "70"
    io.rewind
    $stdin = io

    result = @mock_cli.get_player_params
    $stdin = STDIN

    assert_equal([10,70], result)
  end

  def test_that_the_start_method_returns_a_hash_for_the_game_config
    mock_io = {
      output: "test",
      input: "test"
    }
    io = StringIO.new
    io.puts "s"
    io.puts "10"
    io.puts "70"
    io.rewind
    $stdin = io

    result = @mock_cli.start(mock_io)
    $stdin = STDIN

    assert_equal({ formatter: 'S', row_size: 10, bomb_count: 70 }, result)
  end

  def test_that_it_can_get_a_player_move
    test_io = {
      output: Minesweeper::MockOutput.new,
      input: "test"
    }
    io = StringIO.new
    io.puts "move 5,6"
    io.rewind
    $stdin = io

    out, _err = capture_io do
      @cli.get_move(@mock_game, test_io)
    end
    $stdin = STDIN

    assert_equal("You selected move 5,6. Placing your move.\n", out)
  end

  def test_that_it_can_return_a_string_if_invalid_move
    test_io = {
      output: Minesweeper::Output.new,
      input: "test"
    }
    out, _err = capture_io do
      @cli.invalid_move(test_io)
    end

    assert_equal("That was not a valid move. Please try again.", out)
  end

  def test_that_it_can_return_the_game_over_message
    string = "Game over! You win!\n"

    out, _err = capture_io do
      @cli.show_game_over_message("win")
    end

    assert_equal(out, string)
  end
end
