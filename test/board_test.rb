require 'test_helper'

class BoardTest < Minitest::Test
  
  def setup
    @bomb_positions = [10, 11, 12, 20, 22, 30, 32, 40, 41, 42]
    @board = Minesweeper::Board.new(10, 10, @bomb_positions)

    @bomb_positions04 = [10, 11, 12, 13]
    @board04 = Minesweeper::Board.new(4, 4, @bomb_positions04)

    @bomb_positions08 = [10, 11, 12, 20, 22, 30, 31, 32]
    @board08 = Minesweeper::Board.new(10, 8, @bomb_positions08)

    @bomb_positions11 = [10, 12, 13, 14, 20, 23, 24, 30, 32, 33, 34]
    @board11 = Minesweeper::Board.new(10, 11, @bomb_positions11)

    @bomb_positions12 = [10, 11, 12, 13, 20, 23, 30, 33, 40, 41, 42, 43]
    @board12 = Minesweeper::Board.new(10, 12, @bomb_positions12)

    @bomb_positions13 = [10, 11, 12, 13, 14, 20, 23, 24, 30, 31, 32, 33, 34]
    @board13 = Minesweeper::Board.new(10, 13, @bomb_positions13)

    @bomb_positions14 = [10, 11, 12, 13, 14, 20, 21, 23, 24, 30, 31, 32, 33, 34]
    @board14 = Minesweeper::Board.new(10, 14, @bomb_positions14)
  end

  def test_that_it_initializes_with_a_row_size
    assert_equal 10, @board.row_size
  end

  def test_set_row_size
    assert_equal(10, @board.row_size)
  end

  def test_that_it_initializes_with_a_bomb_count
    assert_equal 10, @board.bomb_count
  end

  def test_that_it_has_a_size_attribute
    assert_equal(100, @board.size)
  end

  def test_that_it_has_a_positions_attribute
    refute_nil @board.positions
  end

  def test_that_set_positions_sets_the_bombs
    refute_nil @board.bomb_positions
  end

  def test_that_it_has_a_bomb_positions_attribute
    refute_nil @board.bomb_positions
  end

  def test_that_it_can_be_initialized_with_a_bomb_positions_array
    assert @board.bomb_positions.size == 10
  end

  def test_that_it_sets_bomb_positions
    assert_equal(10, @board.bomb_positions.size)
  end

  def test_that_set_positions_can_set_the_bomb_positions_1
    assert_equal(10, @board.bomb_positions.size)
  end

  def test_that_set_positions_can_set_the_bomb_positions_2
    assert_operator(0, :<=, @board.bomb_positions.min)
  end

  def test_that_set_positions_can_set_the_bomb_positions_3
    assert_operator(10, :<=, @board.bomb_positions.max)
  end

  def test_that_initialize_sets_a_cell_for_every_position
    assert @board.positions.size == 100
  end

  def test_that_initialize_can_set_the_board_cells
    bomb_count = Hash.new(0)
    @board.positions.each do |cell|
      bomb_count['B'] += 1 if cell.value == 'B'
    end

    assert_equal(10, bomb_count['B'])
  end

  def test_that_initialize_can_set_the_contents_of_the_board_cells
    assert_equal(@board.positions[13].content, ' ')
  end

  def test_that_initialize_can_set_the_value_of_each_board_cell_depending_on_its_neighboring_cells
    assert_equal(@board.positions[13].value, 2)
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

  def test_that_it_can_assign_values_to_board_squares
    position = 21

    result = @board13.assign_value(position)

    assert_equal 7, result
  end

  def test_that_it_can_check_if_a_position_is_empty_1
    position = 64

    result = @board14.is_empty?(position)

    assert result
  end

  def test_that_it_can_check_if_a_position_is_empty_2
    position = 64
    @board11.positions[position].update_cell_value(3)

    result = @board11.is_empty?(position)

    assert(result)
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

  def test_that_it_can_assign_a_value_to_a_position_on_the_board
    position = 22

    result = @board14.assign_value(position)

    assert_equal 8, result
  end

  def test_that_it_can_return_neighboring_cells
    @bomb_positions = [2, 7, 8, 15]
    @board04 = Minesweeper::Board.new(4, 4, @bomb_positions)

    result = @board04.show_adjacent_empties_with_value(0)
    expected_positions = [1, 4, 5]

    assert_equal(expected_positions, result)
  end

  def test_that_it_can_return_neighboring_cells_1
    result = @board04.show_adjacent_empties_with_value(0)
    expected_positions = [1, 4, 5, 2, 6, 8, 9, 3, 7]

    assert_equal(expected_positions, result)
  end

  def test_that_it_can_get_the_neighboring_spaces_to_clear
    result = @board04.show_adjacent_empties_with_value(4)
    expected_positions = [5, 0, 1, 8, 9, 2, 6, 3, 7]

    assert_equal(expected_positions, result)
  end

  def  test_that_it_can_assign_a_value_to_each_position_on_the_board
    @board04.assign_values_to_all_positions
    result = @board04.positions.map{ |cell| cell.value }
    expected_positions = [
      0, 0, 0, 0,
      0, 1, 2, 2,
      2, 3, 'B', 'B',
      'B', 'B', 3, 2
    ]
    assert_equal(expected_positions, result)
  end

  def test_that_it_can_show_adjacent_empties
    index = 0

    result = @board04.show_adjacent_empties_with_value(index)

    assert_equal([1, 4, 5, 2, 6, 8, 9, 3, 7], result)
  end

  def test_that_it_can_clear_adjacent_spaces
    bomb_positions = [1, 6, 10, 13]
    board = Minesweeper::Board.new(4, 4, bomb_positions)
    index = 4
    result = board.show_adjacent_empties_with_value(index)
    assert_equal([5, 0, 8, 9], result)
  end

  def test_that_it_can_clear_adjacent_spaces_when_given_a_position
    position = 21

    result = @board08.show_adjacent_empties_with_value(position)

    assert_equal([], result)
  end

  def test_that_it_can_clear_adjacent_spaces_1
    position = 21

    result = @board.show_adjacent_empties_with_value(position)

    assert_equal([31], result)
  end

  def test_that_it_can_clear_adjacent_spaces_2
    position = 21

    result = @board12.show_adjacent_empties_with_value(position)

    assert_equal([22, 31, 32], result)
  end

  def test_that_it_can_clear_adjacent_spaces_3
    position = 21

    result = @board12.show_adjacent_empties_with_value(position)

    assert_equal([22, 31, 32], result)
  end

  def test_that_it_can_clear_adjacent_spaces_4
    position = 21

    result = @board12.show_adjacent_empties_with_value(position)

    assert_equal([22, 31, 32], result)
  end

  def test_that_setting_empties_returns_a_correctly_sized_array
    position = 88

    @board12.show_adjacent_empties_with_value(position)

    assert_equal(100, @board12.positions.size)
  end

  def test_that_it_can_assign_values_to_empties_in_the_positions_array
    position = 21

    result = @board12.show_adjacent_empties_with_value(position)

    assert_kind_of(Integer, @board12.positions[result.last].value)
  end

  def test_that_it_can_check_if_all_positions_are_empty

    assert(@board12.all_positions_empty?)
  end
end
