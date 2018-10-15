module Minesweeper
  class App
    BOMB_PERCENT = 0.75
    MAX_ROW_NUM = 20

    attr_accessor :game, :cli

    def initialize
      cli = CLI.new
      self.cli = cli
      game_config = cli.start
      game = Game.new(game_config[:row_size], game_config[:bomb_count], game_config[:formatter])
      self.game = game
    end

    def start
      play_game
      end_game
    end

    def play_game
      until game_is_over
        move = nil
        while game.is_not_valid?(move)
          cli.invalid_move if move
          move = cli.get_move(game)
        end
        game.place_move(move)
      end
    end

    def end_game
      result = game.check_win_or_loss
      message = cli.show_game_over_message(result)
      cli.print(message)
    end

    def game_is_over
      game.gameloop_check_status
    end
  end
end
