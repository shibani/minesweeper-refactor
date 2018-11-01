module Minesweeper
  class EndGame

    def run(game, cli, io)
      result = game.check_win_or_loss
      cli.print_board(game, io)
      game_over_message = cli.build_game_over_message(result, io)
      io[:output].display(game_over_message)
    end
  end
end