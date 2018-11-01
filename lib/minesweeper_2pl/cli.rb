module Minesweeper
  class CLI

    attr_reader :messages, :validator

    def initialize(messages, validator)
      @messages = messages
      @validator = validator
    end

    def print(msg, io)
      io[:output].display(msg)
    end

    def start(io)
      io[:output].display(messages.welcome)
      game_config = {}
      game_config[:formatter] = ask_for_emoji_type(io)
      result = get_player_params(io)
      game_config[:row_size] = result[0].to_i
      game_config[:bomb_count] = result[1].to_i
      game_config
    end

    def print_board(game, io)
      board_array = io[:board_formatter].format_board_with_emoji(game.board, game.icon_style)
      io[:board_printer].print_board(board_array, game.board, io)
    end

    def get_move(game, io)
      io[:output].display(messages.ask_for_move)
      get_player_input(game, io)
    end

    def ask_for_emoji_type(io)
      choice = nil
      while choice.nil?
        io[:output].display(messages.ask_for_emoji_type)
        choice = get_emoji_type(io)
      end
      ['S', 's'].include?(choice) ? 'S' : nil
    end

    def invalid_move(io)
      io[:output].display(messages.invalid_move)
    end

    def build_game_over_message(result, io)
      io[:output].display(messages.show_game_over_message(result))
    end

    def get_player_params(io)
      result = []
      size = get_size(io)
      result << size
      result << get_count(io, size)
    end

    def get_size(io)
      size = nil
      while size.nil?
        io[:output].display(messages.ask_for_row_size)
        size = get_player_entered_board_size(io)
      end
      size
    end

    def get_count(io, size)
      count = nil
      while count.nil?
        io[:output].display(messages.ask_for_bomb_count(size))
        count = get_player_entered_bomb_count(size * size, io)
      end
      count
    end

    def get_emoji_type(io)
      input = io[:input].get_input
      if validator.emoji_type_has_correct_format(input)
        return validator.return_emoji_type(input, io)
      end
      io[:output].display(messages.invalid_emoji_type_message)
    end

    def get_player_input(game, io)
      input = io[:input].get_input
      if validator.player_input_has_correct_format(input)
        return validator.return_coordinates_if_input_is_within_range(input, game, io)
      end
      io[:output].display(messages.invalid_player_input_message)
    end

    def get_player_entered_board_size(io)
      input = io[:input].get_input
      if validator.board_size_input_has_correct_format(input)
        return validator.return_row_size_if_input_is_within_range(input, io)
      end
      io[:output].display(messages.invalid_row_size_message)
    end

    def get_player_entered_bomb_count(board_size, io)
      input = io[:input].get_input
      if validator.bomb_count_input_has_correct_format(input)
        return validator.return_bomb_count_if_input_is_within_range(input, board_size, io)
      end
      io[:output].display(messages.invalid_bomb_count_message)
    end
  end
end
