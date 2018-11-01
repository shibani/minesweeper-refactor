module Minesweeper
  class SetupGame
    def run(cli, io)
      game_config = cli.start(io)
      board = Board.new(game_config[:row_size], game_config[:bomb_count])
      Game.new(board, io, game_config[:formatter])
    end
  end
end