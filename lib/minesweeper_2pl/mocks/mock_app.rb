module Minesweeper
  class MockApp < App

    SIZE = 100
    BOMB_COUNT = 10
    BOMB_PERCENT = 0.75

    attr_accessor :game, :cli

    def initialize(game=nil, cli=nil)
      @cli = cli
      @game = game
      @board = game.board
    end

  end
end
