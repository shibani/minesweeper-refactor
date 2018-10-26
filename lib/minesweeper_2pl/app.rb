module Minesweeper
  class App
    BOMB_PERCENT = 0.75
    MAX_ROW_NUM = 20

    def start
      io = {
        output: Output.new,
        input: Input.new,
        board_formatter: BoardFormatter.new,
        board_printer: BoardPrinter.new
      }
      cli = CLI.new
      game = setup_game(cli, io)
      play_game(game, cli, io)
      end_game(game, cli, io)
    end

    def setup_game(cli, io)
      game_config = cli.start(io)
      board = Board.new(game_config[:row_size], game_config[:bomb_count])
      Game.new(board, game_config[:formatter])
    end

    def play_game(game, cli, io)
      until game.game_over
        cli.print_board(game.board, io, game.icon_style)
        move = nil
        while game.is_not_valid?(move)
          cli.invalid_move(io) if move
          move = cli.get_move(game, io)
        end
        game.place_move(move)
      end
      game
    end

    def end_game(game, cli, io)
      result = game.check_win_or_loss(io)
      cli.print_board(game.board, io, game.icon_style)
      message = cli.show_game_over_message(result, io)
      io[:output].display(message)
    end
  end
end
