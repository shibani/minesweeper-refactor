require 'test_helper' 

class GameTest < Minitest::Test

  def test_that_it_can_return_an_array_of_the_boards_flag_positions
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    @game_utils = Minesweeper::GameUtils.new

    to_flag = [20,21,22,23,24]
    to_flag.each { |el|
        @game.board_positions[el].add_flag }

    assert_equal([20,21,22,23,24], @game_utils.board_flags(@board))
  end
end