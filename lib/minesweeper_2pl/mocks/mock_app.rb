module Minesweeper
  class MockApp < App

    SIZE = 100
    BOMB_COUNT = 10
    BOMB_PERCENT = 0.75

    attr_accessor :game, :cli

    def initialize
      cli = MockCli.new
      self.cli = cli
      game = MockGame.new(5,5)
      self.game = game
    end

  end
end
