require "test_helper"

class CellTest < Minitest::Test
  def setup
    @cell1 = Minesweeper::Cell.new('B')
    @cell2 = Minesweeper::Cell.new(' ')
  end

  def test_that_it_initializes_with_content
    assert_equal 'B', @cell1.content
  end

  def test_that_the_content_of_the_cell_can_be_updated
    @cell1.update_cell_content('X')

    assert_equal 'X', @cell1.content
  end

  def test_that_the_value_of_the_cell_can_be_updated
    @cell2.update_cell_value(0)
    assert_equal 0, @cell2.value
  end

  def test_that_the_status_of_the_cell_can_be_updated
    @cell1.update_cell_status
    assert_equal 'revealed', @cell1.status
  end

  def test_that_the_cell_has_an_updateable_flag_property
    @cell1.add_flag
    assert_equal 'F', @cell1.flag
  end

  def test_that_the_flag_property_can_be_unset
    @cell1.add_flag
    @cell1.remove_flag
    assert_nil @cell1.flag
  end
end
