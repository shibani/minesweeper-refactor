require "test_helper"

class PlayerTest < Minitest::Test

  def setup
    @player = Minesweeper::Player.new
  end

  def test_that_it_has_a_player_class
    refute_nil @player
  end

end
