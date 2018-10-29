require 'test_helper' 

class AdjacentEmptiesTest < Minitest::Test

def setup
  @bomb_positions = [10, 11, 12, 20, 22, 30, 32, 40, 41, 42]
  @board = Minesweeper::Board.new(10, 10, @bomb_positions)

  @bomb_positions04 = [10, 11, 12, 13]
  @board04 = Minesweeper::Board.new(4, 4, @bomb_positions04)

  @bomb_positions08 = [10, 11, 12, 20, 22, 30, 31, 32]
  @board08 = Minesweeper::Board.new(10, 8, @bomb_positions08)

  @bomb_positions12 = [10, 11, 12, 13, 20, 23, 30, 33, 40, 41, 42, 43]
  @board12 = Minesweeper::Board.new(10, 12, @bomb_positions12)
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

end