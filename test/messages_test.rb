require 'stringio'
require 'test_helper'
require 'io_test_helpers'

class MessagesTest < Minitest::Test
  include IoTestHelpers

  def setup
    @cli = Minesweeper::Messages
    @messages = Minesweeper::Messages.new
  end

  def test_that_the_welcome_method_welcomes_the_user
    message = @messages.welcome
    string = "\n===========================================\n           WELCOME TO MINESWEEPER\n===========================================\n\n"

    assert_equal(string, message)
  end

  def test_that_it_asks_for_emoji_type
    message = @messages.ask_for_emoji_type
    string = "\nPlayer 1 would you like to play with traditional bombs or would you like a surprise?\nEnter B for bombs or S for surprise:\n"
    assert_equal(string, message)
  end

  def test_that_it_asks_for_a_move
    message = @messages.ask_for_move
    string = "\nPlayer 1, make your move:\n- to place a move: enter the word 'move' followed by one digit from the header and one digit from the left column, eg. move 3,1:\n- to place (or remove) a flag: enter the word 'flag' followed by the desired coordinates eg flag 3,1\n"

    assert_equal(string, message)
  end

  def test_that_it_can_has_an_invalid_emoji_type_message
    message = @messages.invalid_emoji_type_message
    string = 'That was not a valid choice. Please try again.'

    assert_equal(string, message)
  end

  def test_that_it_has_an_invalid_move_message
    message = @messages.invalid_move
    string = 'That was not a valid move. Please try again.'

    assert_equal(string, message)
  end

  def test_that_it_can_send_an_invalid_bomb_count_message
    message = @messages.invalid_bomb_count_message
    string = 'That is not a valid bomb count. Please try again.'

    assert_equal(string, message)
  end

  def test_that_it_has_a_bomb_count_success_message
    message = @messages.bomb_count_success_message(6)
    string = 'You selected 6. Setting bombs!'

    assert_equal(string, message)
  end

  def test_that_it_can_send_an_invalid_row_size_message
    message = @messages.invalid_row_size_message
    string = 'That is not a valid row size. Please try again.'

    assert_equal(string, message)
  end

  def test_that_it_has_a_row_size_success_message
    message = @messages.row_size_success_message(10)
    string = 'You have selected a 10 x 10 board. Generating board.'

    assert_equal(string, message)
  end

  def test_that_it_has_an_invalid_player_input_message
    message = @messages.invalid_player_input_message
    string = 'Expecting \'flag\' or \'move\', with one digit from header and one digit from left column. Please try again!'

    assert_equal(string, message)
  end

  def test_that_it_can_send_a_player_input_success_message
    message = @messages.player_input_success_message('move 0,0')
    string = 'You selected move 0,0. Placing your move.'

    assert_equal(string, message)
  end

  def test_that_it_can_ask_player_to_set_board_size
    message = @messages.ask_for_row_size
    string = "Player 1 please enter a row size for your board, any number less than or equal to 20. \n(Entering 20 will give you a 20X20 board)\n"

    assert_equal(string, message)
  end

  def test_that_it_can_ask_player_to_set_bomb_count
    message = @messages.ask_for_bomb_count(10)
    string = "\nPlayer 1 please enter the number of bombs there should be on the board. \n(The number should not be more than 75)\n"

    assert_equal(string, message)
  end

  def test_that_it_has_a_show_game_lost_message
    message = @messages.show_game_over_message('lose')
    string = "\nGame over! You lose.\n"

    assert_equal(string, message)
  end

  def test_that_it_has_a_show_game_won_message
    message = @messages.show_game_over_message("win")
    string = "\nGame over! You win!\n"

    assert_equal(string, message)
  end
end
