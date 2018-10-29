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

  def test_that_it_can_assign_a_value_to_a_position_on_the_board
    position = 22

    result = @board14.assign_value(position)

    assert_equal 8, result
  end

  def test_that_it_can_check_if_all_positions_are_empty

    assert(@board12.all_positions_empty?)
  end
end
