# require "test_helper"

# class NeighboringCellsTest < Minitest::Test

#   def setup
#     @bomb_positions13 = [10, 11, 12, 13, 14, 20, 23, 24, 30, 31, 32, 33, 34]
#     @board13 = Minesweeper::Board.new(10, 13, @bomb_positions13)
#   end

#   def test_that_it_can_collect_neighboring_cells_when_given_a_position
#     position = 21

#     result = @board13.neighboring_cells.get_cells(position)

#     assert_equal([20, 22, 10, 11, 12, 30, 31, 32], result)
#   end

#   def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_bottom_bounds
#     position = 1

#     result = @board13.neighboring_cells.cells(position)

#     assert_equal([0, 2, 10, 11, 12], result)
#   end

#   def test_that_it_can_collect_neighboring_empty_cells_when_given_a_position
#     position = 21
#     result = @board13.neighboring_cells.cells(position, true)
#     assert_equal([22], result)
#   end

#   def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_top_bounds
#     position = 98

#     result = @board13.neighboring_cells.cells(position)

#     assert_equal([97, 99, 87, 88, 89], result)
#   end

#   def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_left_bounds
#     position = 60

#     result = @board13.neighboring_cells.cells(position)

#     assert_equal([61, 50, 51, 70, 71], result)
#   end

#   def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_right_bounds
#     position = 59

#     result = @board13.neighboring_cells.cells(position)

#     assert_equal([58, 48, 49, 68, 69], result)
#   end
# end
