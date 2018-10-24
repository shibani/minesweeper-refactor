module Minesweeper
  class CLI
    def print(msg)
      puts(msg)
    end

    def start(io)
      io[:output].display(Messages.welcome)
      game_config = {}
      game_config[:formatter] = ask_for_emoji_type(io)
      result = get_player_params(io)
      game_config[:row_size] = result[0].to_i
      game_config[:bomb_count] = result[1].to_i
      game_config
    end

    def get_move(game, io)
      io[:output].display(Messages.ask_for_move)
      get_player_input(game, io)
    end

    def ask_for_emoji_type(io)
      choice = nil
      while choice.nil?
        io[:output].display(Messages.ask_for_emoji_type)
        choice = get_emoji_type(io)
      end
      ['S', 's'].include?(choice) ? 'S' : nil
    end

    def invalid_move(io)
      io[:output].display(Messages.invalid_move)
    end

    def show_game_over_message(result)
      puts Messages.show_game_over_message(result)
    end

    def get_player_params(io)
      result = []
      size = nil
      while size.nil?
        io[:output].display(Messages.ask_for_row_size)
        size = get_player_entered_board_size
      end
      result << size
      count = nil
      while count.nil?
        io[:output].display(Messages.ask_for_bomb_count(size))
        count = get_player_entered_bomb_count(size * size, io)
      end
      result << count
      result
    end

    def get_emoji_type(io)
      input = gets.chomp
      if InputValidator.emoji_type_has_correct_format(input)
        result = InputValidator.return_emoji_type(input)
      else
        io[:output].display(Messages.invalid_emoji_type_message)
        result = nil
      end
      result
    end

    def get_player_input(game, io)
      input = gets.chomp
      if InputValidator.player_input_has_correct_format(input)
        InputValidator.return_coordinates_if_input_is_within_range(input, game)
      else
        io[:output].display(Messages.invalid_player_input_message)
      end
    end

    def get_player_entered_board_size(io)
      input = gets.chomp
      if InputValidator.board_size_input_has_correct_format(input)
        InputValidator.return_row_size_if_input_is_within_range(input)
      else
        io[:output].display(Messages.invalid_row_size_message)
      end
    end

    def get_player_entered_bomb_count(board_size, io)
      input = gets.chomp
      if InputValidator.bomb_count_input_has_correct_format(input)
        InputValidator.return_bomb_count_if_input_is_within_range(input, board_size)
      else
        io[:output].display(Messages.invalid_bomb_count_message)
      end
    end
  end
end
