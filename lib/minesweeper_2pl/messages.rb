module Minesweeper
  class Messages
    def self.welcome
      "\n===========================================\n           WELCOME TO MINESWEEPER\n===========================================\n\n"
    end

    def self.ask_for_move
      "\nPlayer 1, make your move:\n- to place a move: enter the word 'move' followed by one digit from the header and one digit from the left column, eg. move 3,1:\n- to place (or remove) a flag: enter the word 'flag' followed by the desired coordinates eg flag 3,1\n"
    end

    def self.ask_for_emoji_type
      "\nPlayer 1 would you like to play with traditional bombs or would you like a surprise?\nEnter B for bombs or S for surprise:\n"
    end

    def self.return_emoji_type(input)
      if ['B', 'b'].include?(input)
        "You selected B for bombs.\n"
      else
        "You selected S, prepare for a surprise!\n"
      end
    end

    def self.invalid_emoji_type_message
      "That was not a valid choice. Please try again."
    end

    def self.ask_for_row_size
      "Player 1 please enter a row size for your board, any number less than or equal to 20. \n(Entering 20 will give you a 20X20 board)\n"
    end

    def self.ask_for_bomb_count(size)
      "Player 1 please enter the number of bombs there should be on the board. \n(The number should not be more than #{(size * size * App::BOMB_PERCENT).to_i})"
    end

    def self.invalid_move
      "That was not a valid move. Please try again."
    end

    def self.invalid_bomb_count_message
      "That is not a valid bomb count. Please try again."
    end

    def self.bomb_count_success_message(input)
      "You selected #{input}. Setting bombs!"
    end

    def self.show_game_over_message(result)
      if result == "win"
        "Game over! You win!"
      elsif result == "lose"
        "Game over! You lose."
      end
    end

    def self.invalid_player_input_message
      "Expecting 'flag' or 'move', with one digit from header and one digit from left column. Please try again!"
    end

    def self.row_size_success_message(input)
      "You have selected a #{input} x #{input} board. Generating board."
    end

    def self.invalid_row_size_message
      "That is not a valid row size. Please try again."
    end

    def self.player_input_success_message(input)
      move = input.split(" ")
      "You selected #{input}. Placing your #{move[0]}."
    end
  end
end
