require 'test_helper' 

class GameUtilsTest < Minitest::Test

  def setup
    @bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, @bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    @game_utils = Minesweeper::GameUtils.new
  end

  def test_that_it_can_get_the_games_board_positions
    result = @game_utils.board_positions(@board)
    assert_equal 25, result.size
  end

  def test_that_it_can_return_an_array_of_the_boards_flag_positions
    expected_values = [
      0, 0, 0, 0, 0, 
      2, 3, 3, 3, 2, 
      "B", "B", "B", "B", "B", 
      2, 3, 3, 3, 2, 
      0, 0, 0, 0, 0
    ]

    assert_equal(expected_values, @game_utils.board_values(@board))
  end

  def test_that_it_can_return_an_array_of_the_boards_flag_positions
    to_flag = [20,21,22,23,24]
    to_flag.each { |el|
        @game.board_positions[el].add_flag }

    assert_equal([20,21,22,23,24], @game_utils.board_flags(@board))
  end

  def test_that_it_can_set_the_status_of_an_array_of_cells_to_revealed
    to_reveal = [20,21,22,23,24]

    @game.set_cell_status(to_reveal)
    result = @game_utils.board_cell_status(@board)

    assert_equal(to_reveal, result)
  end

  def test_that_it_can_return_the_board_values
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    expected = [0, 0, 0, 0, 0, 2, 3, 3, 3, 2, 'B', 'B', 'B', 'B', 'B', 2, 3, 3, 3, 2, 0, 0, 0, 0, 0]
    assert_equal(expected, @game.board_values)
  end

  def test_that_it_can_return_the_boards_cell_status
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    to_reveal = [20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }

    assert_equal(to_reveal, @game.board_cell_status)
  end

  def test_that_it_can_check_if_a_move_is_valid_1
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    to_reveal = [0,1,2,3,4]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    move = [0,0, "move"]

    assert(@game.is_not_valid?(move))
  end

  def test_that_it_can_check_if_a_move_is_valid_2
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = nil

    assert(@game_utils.is_not_valid?(move))
  end

  def test_that_it_can_access_position_by_coordinates
    bomb_positions = [13, 15, 16, 18, 19]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    move = [3,3, 'move']

    assert_equal 'B', @game_utils.get_position(@board, move).content
  end

  def test_that_it_can_place_a_move_on_the_board
    bomb_positions = [13, 15, 16, 18, 19]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [0, 0, 'move']

    @game.place_move(move)

    assert_equal 'revealed', @game_utils.get_position(@board, move).status
  end

  def test_that_it_can_convert_a_move_to_a_position
    move = [3, 3, 'move']
    assert_equal @game_utils.move_to_position(@board, move), 18
  end

  def test_that_it_can_get_a_position_given_a_board_and_a_position
    position = 18
    result = @game_utils.board_position_at(@board, position)
    assert_equal result.value, 3 
  end

  def test_that_it_can_get_a_position_given_a_board_and_a_position
    position = 18
    result = @game_utils.board_position_at(@board, position)
    assert_equal result.value, 3 
  end

  def test_that_it_can_check_if_a_position_is_a_bomb
    position = 13

    assert @game_utils.position_is_a_bomb?(@board, position)
  end

  def test_that_it_can_check_if_a_position_is_empty
    position = 18

    assert @game_utils.position_is_empty?(@board, position)
  end

  def test_that_it_can_check_if_a_position_is_a_flag
    position = 23
    to_flag = [20,21,22,23,24]
    to_flag.each { |el|
      @game_utils.mark_flag(@board, el) }

    assert @game_utils.position_is_empty?(@board, position)
  end

  def test_that_it_can_check_if_position_has_a_zero_value
    position = 3
    assert @game_utils.position_has_a_zero_value?(@board, position)
  end

  def test_that_it_can_check_if_position_has_a_non_zero_value
    position = 8
    assert @game_utils.position_has_a_non_zero_value?(@board, position)
  end

  def test_that_it_can_mark_a_flag
    position = 23
    @game_utils.mark_flag(@board, position)
    assert_equal @game_utils.board_flags(@board), [23]
  end
  
  def test_that_it_can_return_the_bomb_positions_given_a_board
    assert_equal [10, 11, 12, 13, 14], @game_utils.bomb_positions(@board) 
  end

  def test_that_it_can_check_if_all_bomb_positions_are_flagged
    to_flag = [10, 11, 12, 13, 14]
    to_flag.each { |el|
        @game_utils.mark_flag(@board, el) }

    assert @game_utils.all_bomb_positions_are_flagged?(@board)
  end

  def test_that_it_can_check_if_a_move_is_the_first_move
    assert @game_utils.first_move?(@board)
  end
end
