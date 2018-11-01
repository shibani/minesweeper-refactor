require 'test_helper' 

class NeighboringCellsTest < Minitest::Test

  def setup
    @bomb_positions11 = [10, 12, 13, 14, 20, 23, 24, 30, 32, 33, 34]
    @board11 = Minesweeper::Board.new(10, 11, @bomb_positions11)

    @bomb_positions13 = [10, 11, 12, 13, 14, 20, 23, 24, 30, 31, 32, 33, 34]
    @board13 = Minesweeper::Board.new(10, 13, @bomb_positions13)

    @neighboring_cells = Minesweeper::NeighboringCells.new
  end

  def test_that_it_can_check_if_a_cell_is_the_current_cell
    row_offset = 0
    cell_offset = 0

    assert(@neighboring_cells.current_cell?(row_offset, cell_offset))
  end

  def test_that_it_can_collect_neighboring_cells_when_given_a_position
    position = 21

    result = @board13.neighboring_cells(position)

    assert_equal([20, 22, 10, 11, 12, 30, 31, 32].sort, result.sort)
  end

  def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_bottom_bounds
    position = 1

    result = @board13.neighboring_cells(position)

    assert_equal([0, 2, 10, 11, 12].sort, result.sort)
  end

  def test_that_it_can_collect_neighboring_empty_cells_when_given_a_position
    position = 21
    result = @board13.neighboring_cells(position, true)
    assert_equal([22], result)
  end

  def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_top_bounds
    position = 98

    result = @board13.neighboring_cells(position)

    assert_equal([97, 99, 87, 88, 89].sort, result.sort)
  end

  def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_left_bounds
    position = 60

    result = @board13.neighboring_cells(position)

    assert_equal([61, 50, 51, 70, 71].sort, result.sort)
  end

  def test_that_it_can_collect_neighboring_cells_when_given_a_position_close_to_right_bounds
    position = 59

    result = @board13.neighboring_cells(position)

    assert_equal([58, 48, 49, 68, 69].sort, result.sort)
  end

  def test_that_it_can_collect_all_neigbhoring_empty_positions_1
    position = 21
    result = @board13.neighboring_cells(position, true)
    assert_equal 1, result.size
  end

  def test_that_it_can_collect_all_neighboring_empty_positions_2
    position = 21
    result = @board11.neighboring_cells(position, true)
    assert_equal 3, result.size
  end
end
