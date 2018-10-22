module Minesweeper
  class App
    BOMB_PERCENT = 0.75
    MAX_ROW_NUM = 20

    def start
      cli = CLI.new
      game = setup_game(cli)
      play_game(game, cli)
      end_game(game, cli)
    end

    def setup_game(cli)
      game_config = cli.start
      board = Board.new(game_config[:row_size], game_config[:bomb_count])
      Game.new(board, game_config[:formatter])
    end

    def play_game(game, cli)
      until game_is_over(game)
        move = nil
        while game.is_not_valid?(move)
          cli.invalid_move if move
          move = cli.get_move(game)
        end
        game.place_move(move)
      end
      game
    end

    def end_game(game, cli)
      result = game.check_win_or_loss
      message = cli.show_game_over_message(result)
      cli.print(message)
    end

    def game_is_over(game)
      game.gameloop_check_status
    end
  end
end
