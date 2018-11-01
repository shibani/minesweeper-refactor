require 'stringio'
require "test_helper"
require "io_test_helpers"

class InputValidatorTest < Minitest::Test
  include IoTestHelpers

  def setup
    @messages = Minesweeper::Messages.new
    @test_validator = Minesweeper::InputValidator.new(@messages)
    @board = Minesweeper::Board.new(10,10)
    @test_io = { output: Minesweeper::Output.new, input: Minesweeper::Input.new }
    @game = Minesweeper::Game.new(@board, @test_io)
  end

  def test_that_it_can_check_if_bomb_count_does_not_have_correct_format
    input = 'teststring'
    refute @test_validator.bomb_count_input_has_correct_format(input)
  end

  def test_that_it_can_check_if_bomb_count_has_correct_format
    input = '75'
    assert input, @test_validator.bomb_count_input_has_correct_format(input)
  end

  def test_that_it_can_check_if_board_size_input_does_not_have_correct_format
    input = 'jslkdjflsjd'
    assert_nil @test_validator.bomb_count_input_has_correct_format(input)
  end

  def test_that_it_can_check_if_board_size_input_has_correct_format
    input = '25'
    assert input, @test_validator.bomb_count_input_has_correct_format(input)
  end

  def test_that_it_can_check_if_the_bomb_count_is_within_a_valid_range
    input = '70'
    board_size = 100
    assert @test_validator.bomb_count_within_range?(input, board_size)
  end

  def test_that_it_can_check_if_the_bomb_count_is_not_within_a_valid_range
    input = '85'
    board_size = 100
    refute @test_validator.bomb_count_within_range?(input, board_size)
  end

  def test_that_it_can_check_if_rowsize_is_within_a_valid_range
    input = '4'
    assert @test_validator.row_size_within_range?(input)
  end

  def test_that_it_can_check_if_rowsize_is_not_within_a_valid_range
    input = '24'
    refute @test_validator.row_size_within_range?(input)
  end

  def test_that_it_can_check_if_emoji_type_input_has_correct_format
    assert @test_validator.emoji_type_has_correct_format('B')
    assert @test_validator.emoji_type_has_correct_format('b')
    assert @test_validator.emoji_type_has_correct_format('S')
    assert @test_validator.emoji_type_has_correct_format('s')
  end

  def test_that_it_can_return_validated_coordinates
    input = "move 1,3"
    assert_output "You selected move 1,3. Placing your move." do
      simulate_stdin() {@test_validator.return_coordinates_if_input_is_within_range(input, @game, @test_io)}
    end
  end

  def test_that_it_can_return_the_validated_row_size
    input = "8"
    assert_output "You have selected a 8 x 8 board. Generating board." do
      simulate_stdin() {@test_validator.return_row_size_if_input_is_within_range(input, @test_io)}
    end
  end

  def test_that_it_can_return_the_validated_bomb_count
    input = "10"
    assert_output "You selected 10. Setting bombs!" do
      simulate_stdin() {@test_validator.return_bomb_count_if_input_is_within_range(input, 64, @test_io)}
    end
  end
end
