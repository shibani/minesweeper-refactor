require 'stringio'
require 'test_helper'
require 'io_test_helpers'

class MessagesTest < Minitest::Test
  include IoTestHelpers

  def setup
    @cli = Minesweeper::Messages
  end

  def test_that_the_welcome_method_welcomes_the_user
    message = @cli.welcome
    string = "\n===========================================\n           WELCOME TO MINESWEEPER\n===========================================\n\n"

    assert_equal(string, message)
  end

  def test_that_it_asks_for_emoji_type
    assert_equal("\nPlayer 1 would you like to play with traditional bombs or would you like a surprise?\nEnter B for bombs or S for surprise:\n", @cli.ask_for_emoji_type)
  end

  def test_that_it_asks_for_a_move
    assert_equal("\nPlayer 1, make your move:\n- to place a move: enter the word 'move' followed by one digit from the header and one digit from the left column, eg. move 3,1:\n- to place (or remove) a flag: enter the word 'flag' followed by the desired coordinates eg flag 3,1\n", @cli.ask_for_move)
  end

  def test_that_it_can_has_an_invalid_emoji_type_message
    assert_equal("That was not a valid choice. Please try again.", @cli.invalid_emoji_type_message)
  end

  def test_that_it_has_an_invalid_move_message
    assert_equal("That was not a valid move. Please try again.", @cli.invalid_move)
  end

  def test_that_it_can_send_an_invalid_bomb_count_message
    assert_equal("That is not a valid bomb count. Please try again.", @cli.invalid_bomb_count_message)
  end

  def test_that_it_has_a_bomb_count_success_message
    assert_equal("You selected 6. Setting bombs!", @cli.bomb_count_success_message(6))
  end

  def test_that_it_can_send_an_invalid_row_size_message
    assert_equal("That is not a valid row size. Please try again.", @cli.invalid_row_size_message)
  end

  def test_that_it_has_a_row_size_success_message
    assert_equal("You have selected a 10 x 10 board. Generating board.", @cli.row_size_success_message(10))
  end

  def test_that_it_has_an_invalid_player_input_message
    assert_equal("Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!", @cli.invalid_player_input_message)
  end

  def test_that_it_can_send_a_player_input_success_message
    assert_equal("You selected move 0,0. Placing your move.", @cli.player_input_success_message("move 0,0"))
  end

  def test_that_it_can_ask_player_to_set_board_size
    assert_equal("Player 1 please enter a row size for your board, any number less than or equal to 20. \n(Entering 20 will give you a 20X20 board)\n", @cli.ask_for_row_size)
  end

  def test_that_it_can_ask_player_to_set_bomb_count
    assert_includes(@cli.ask_for_bomb_count(10), "\nPlayer 1 please enter the number of bombs there should be on the board. \n(The number should not be more than 75)\n")
  end

  def test_that_it_has_a_show_game_lost_message
    assert_equal("\nGame over! You lose.\n", @cli.show_game_over_message("lose"))
  end

  def test_that_it_has_a_show_game_won_message
    assert_equal("\nGame over! You win!\n", @cli.show_game_over_message("win"))
  end
end
