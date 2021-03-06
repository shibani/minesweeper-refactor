module Minesweeper
  class App
    BOMB_PERCENT = 0.75
    MAX_ROW_NUM = 20

    def start
      io = {
        output: Output.new,
        input: Input.new,
        board_formatter: CliBoardFormatter.new,
        board_printer: BoardPrinter.new
      }
      messages = Messages.new
      validator = InputValidator.new(messages)
      cli = CLI.new(messages, validator)
      
      game = SetupGame.new.run(cli, io)
      PlayGame.new.run(game, cli, io)
      EndGame.new.run(game, cli, io)
    end
  end
end
