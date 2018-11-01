module Minesweeper
  class PlayGame
    def run(game, cli, io)
      until game.game_over
        cli.print_board(game, io)
        move = nil
        while game.is_not_valid?(move)
          cli.invalid_move(io) if move
          move = cli.get_move(game, io)
        end
        game.place_move(move)
      end
      game
    end
  end
end