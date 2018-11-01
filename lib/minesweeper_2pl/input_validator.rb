module Minesweeper
  class InputValidator
    attr_reader :messages

    def initialize(messages)
      @messages = messages
    end

    def bomb_count_input_has_correct_format(input)
      input.match(/^(\d)+$/)
    end

    def bomb_count_within_range?(input, board_size)
      input.to_i > 0 && input.to_i <= board_size * App::BOMB_PERCENT
    end

    def board_size_input_has_correct_format(input)
      input.match(/^(\d)+$/)
    end

    def row_size_within_range?(input)
      input.to_i > 0 && input.to_i <= App::MAX_ROW_NUM
    end

    def emoji_type_has_correct_format(input)
      ['B', 'b', 'S', 's'].include?(input)
    end

    def return_emoji_type(input, io)
      io[:output].display(messages.return_emoji_type(input))
      input
    end

    def player_input_has_correct_format(input)
      input =~ (/(flag|move)\s+[(\d){1,2}],\s*[(\d){1,2}]/)
    end

    def player_input_is_within_range?(coords, game)
      (coords[0].to_i <= game.board.row_size) && (coords[1].to_i <= game.board.row_size)
    end

    def return_coordinates_if_input_is_within_range(input, game, io)
      move = input.split(" ")
      coords = move[1].split(",")
      if player_input_is_within_range?(coords, game)
        io[:output].display(messages.player_input_success_message(input))
        coords = [coords[0].to_i, coords[1].to_i, move[0]]
      else
        io[:output].display(messages.invalid_player_input_message)
        coords = nil
      end
      coords
    end

    def return_row_size_if_input_is_within_range(input, io)
      if row_size_within_range?(input)
        io[:output].display(messages.row_size_success_message(input))
        row_size = input.to_i
      else
        io[:output].display(messages.invalid_row_size_message)
        row_size = nil
      end
      row_size
    end

    def return_bomb_count_if_input_is_within_range(input, board_size, io)
      if bomb_count_within_range?(input, board_size)
        io[:output].display(messages.bomb_count_success_message(input))
        bomb_count = input.to_i
      else
        io[:output].display(messages.invalid_bomb_count_message)
        bomb_count = nil
      end
      bomb_count
    end
  end
end
