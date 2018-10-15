require "test_helper"

class GameTest < Minitest::Test
  def setup
    @game = Minesweeper::MockGame.new(5,5)
    @game2 = Minesweeper::MockGame.new(4,0)
    @game3 = Minesweeper::MockGame.new(4,0,'S')
  end

  def test_that_it_has_a_game_class
    refute_nil @game
  end

  def test_that_initialize_can_create_a_new_board
    refute_nil @game.board
  end

  def test_that_initialize_creates_a_new_board_with_row_size
    assert_equal 5, @game.board.row_size
  end

  def test_that_initialize_creates_a_new_board_with_bomb_count
    assert_equal 5, @game.board.bomb_count
  end

  def test_that_initialize_can_create_a_new_boardcli
    refute_nil @game.formatter
  end

  def test_that_initialize_creates_the_icon_style
    refute_nil @game.icon_style
  end

  def test_that_initialize_creates_the_icon_style_2
    assert @game3.icon_style.instance_of?(Minesweeper::CatEmoji)
  end

  def test_that_initialize_can_set_the_rowsize
    result = @game.board.row_size

    assert_equal 5, result
  end

  def test_that_initialize_can_set_the_board_size
    result = @game.board.size

    assert_equal 25, result
  end

  def test_that_initialize_can_set_the_bomb_count
    result = @game.board.bomb_count

    assert_equal 5, result
  end

  def test_that_initialize_can_set_the_boards_positions
    assert_equal 25, @game.board_positions.size
  end

  def test_that_set_positions_sets_the_value_of_every_position
    positions = ' , , , , , , , , , ,B,B,B,B, , '.split(",")
    bomb_positions = [10, 11, 12, 13]
    @game2.set_bomb_positions(bomb_positions)
    @game2.set_positions(positions)

    result = @game2.board_positions.map{|cell| cell.value}
    @game2.set_positions(result)
    expected_positions = [
      0, 0, 0, 0,
      0, 1, 2, 2,
      2, 3, 'B', 'B',
      'B', 'B', 3, 2
    ]

    assert_equal(expected_positions, result)
  end

  def test_that_it_can_print_the_board
    @game.set_input!("printed board goes here")

    out, err = capture_io do
      @game.print_board
    end
    assert_equal "printed board goes here", out
  end

  def test_that_it_can_set_the_bomb_positions_with_an_array
    bomb_positions = [10, 11, 12, 13, 14]
    @game.set_bomb_positions(bomb_positions)

    assert_matched_arrays bomb_positions, @game.board.bomb_positions
  end

  def test_that_it_can_set_the_board_positions_with_an_array
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_positions(positions)
    content = @game.board_positions.map{ |position| position.content}

    assert_equal positions, content
  end

  def test_that_it_can_get_the_games_row_size
    assert_equal 5, @game.row_size
  end

  def test_that_it_can_get_the_games_bomb_count
    assert_equal 5, @game.bomb_count
  end

  def test_that_it_can_get_the_games_board_positions
    result = @game.board_positions

    assert_equal 25, result.size
  end

  def test_that_it_can_access_position_by_coordinates
    bomb_positions = [13, 15, 16, 18, 19]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", "B", " ",
                  "B", "B", "X", "B", "B",
                  " ", " ", " ", " ", " "]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    move = [3,3, 'move']

    assert_equal 'B', @game.get_position(move).content
  end

  def test_that_it_can_place_a_move_on_the_board
    bomb_positions = [13, 15, 16, 18, 19]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", "B", " ",
                  "B", "B", " ", "B", "B",
                  " ", " ", " ", " ", " "]
    @game.set_bomb_positions(bomb_positions)
    move = [0,0, 'move']

    @game.place_move(move)

    assert_equal 'revealed', @game.get_position(move).status
  end

  def test_that_it_has_a_game_over_attribute
    @game.respond_to?('game over')
  end

  def test_that_it_can_set_the_game_to_game_over
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,12,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    move = [3,2, 'move']

    @game.place_move(move)

    assert @game.game_over
  end

  def test_that_it_can_set_a_flag
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B ", "B ", "B ", "B ", "B ",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = [0,1, 'flag']

    @game.place_move(move)

    assert_equal 'F', @game.get_position(move).flag
  end

  def test_that_it_can_remove_a_flag
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B ", "B", "B", "B ", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = [1,2, 'flag']

    @game.place_move(move)
    @game.place_move(move)

    assert_nil @game.get_position(move).flag
  end

  def test_that_it_can_check_if_a_game_is_over_1
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    move = [2,2, 'flag']

    @game.place_move(move)

    assert @game.is_won?
  end

  def test_that_it_can_check_if_a_game_is_over_2
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    move1 = [0,1, 'move']
    move2 = [2,2, 'move']

    @game.place_move(move1)
    @game.place_move(move2)

    assert @game.game_over
  end

  def test_that_it_can_check_if_a_game_is_over_3
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    move = [0,1, 'flag']

    @game.place_move(move)

    refute @game.game_over
  end

  def test_that_it_can_set_the_Formatters_show_bombs_attribute
    @game.show_bombs = "show"

    assert_equal("show", @game.formatter.show_bombs)
  end

  def test_that_it_can_turn_off_the_Formatters_show_bombs_attribute
    @game.show_bombs = "random string"

    refute @game.formatter.show_bombs
  end

  def test_that_it_can_set_the_Formatters_show_bombs_attribute_to_won
    @game.show_bombs = "won"

    assert_equal("won", @game.formatter.show_bombs)
  end

  def test_that_it_can_check_if_a_game_is_won
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    move = [2,2, "flag"]

    @game.place_move(move)

    assert(@game.is_won?)
  end

  def test_that_it_can_check_if_the_game_is_won
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,12,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }

    assert(@game.is_won?)
  end

  def test_that_it_can_check_if_the_game_is_not_won
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    to_reveal =  [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    refute(@game.is_won?)
  end

  def test_that_it_can_check_if_a_move_is_valid_1
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    to_reveal = [0,1,2,3,4]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    move = [0,0, "move"]

    assert(@game.is_not_valid?(move))
  end

  def test_that_it_can_check_if_a_move_is_valid_2
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = nil

    assert(@game.is_not_valid?(move))
  end

  def test_that_gameloop_check_status_can_check_if_the_game_is_over
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,12,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }

    refute(@game.gameloop_check_status)
  end

  def test_that_gameloop_check_status_can_print_the_board
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [10,11,12,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }

    @game.game_over = false
    @game.set_input!("display board")

    out, err = capture_io do
      @game.gameloop_check_status
    end

    assert_equal("display board", out)
  end

  def test_that_it_can_check_if_the_game_is_won_or_lost
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    bomb_positions.each { |flag| @game.mark_flag_on_board(flag) }
    @game.game_over = true

    assert_equal("win", @game.check_win_or_loss)
  end

  def test_that_it_can_check_if_the_game_is_won_or_lost_2
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = [0,2, 'move']

    @game.place_move(move)
    @game.game_over = true

    assert_equal('lose', @game.check_win_or_loss)
  end

  def test_that_it_a_game_is_lost_all_its_bomb_positions_are_set_to_revealed
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    @game.mark_flag_on_board(10)
    @game.mark_flag_on_board(11)
    move = [0,2, 'move']

    @game.place_move(move)
    @game.game_over = true
    @game.check_win_or_loss

    assert_equal('revealed', @game.board_positions[10].status)
  end

  def test_that_it_sets_a_square_to_revealed_after_marking_a_move
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    @game.mark_move_on_board(9)

    assert_equal('revealed', @game.board_positions[9].status)
  end


  def test_that_revealed_cells_have_revealed_status
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    @game.mark_move_on_board(9)

    assert_equal('revealed', @game.board_positions[8].status)
    assert_equal('revealed', @game.board_positions[3].status)
    assert_equal('revealed', @game.board_positions[4].status)
    assert_equal('revealed', @game.board_positions[2].status)
    assert_equal('revealed', @game.board_positions[7].status)
    assert_equal('revealed', @game.board_positions[1].status)
    assert_equal('revealed', @game.board_positions[6].status)
    assert_equal('revealed', @game.board_positions[0].status)
    assert_equal('revealed', @game.board_positions[5].status)
  end

  def test_that_it_can_mark_a_flag_on_the_board
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    result = @game.mark_flag_on_board(16)
    assert_equal('F', result)
  end

  def test_that_it_doesnt_mark_a_flag_if_position_is_revealed
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }

    @game.mark_flag_on_board(4)

    assert_nil @game.board_positions[4].flag
    assert 'revealed', @game.board_positions[4].status
  end

  def test_that_it_marks_a_flag_if_position_contains_an_integer
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    @game.mark_flag_on_board(4)

    assert_equal('F', @game.board_positions[4].flag)
  end

  def test_that_flood_fill_returns_adjacent_empties_1
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    to_reveal = [20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }
    result = @game.flood_fill(9)

    assert_equal([8,3,4,2,7,1,6,0,5,9], result)
  end

  def test_that_flood_fill_returns_adjacent_empties_when_position_is_a_bomb
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    result = @game.flood_fill(10)

    assert_equal([5,6,15,16,10], result)
  end

  def test_that_flood_fill_does_not_return_flagged_positions
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    flags = [5,6]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    result = @game.flood_fill(10)

    assert_equal([15,16,10], result)
  end

  def test_that_reassign_bombs_can_prevent_first_move_from_ending_the_game
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = [2,2, "move"]

    @game.place_move(move)

    refute @game.game_over
  end

  def test_that_reveal_self_can_set_status_of_position_to_revealed
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    position = 15

    @game.reveal_self(position)

    assert_equal('revealed', @game.board_positions[position].status)
  end

  def test_that_reassign_bombs_can_update_the_bombs_positions_array
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    @game.reassign_bomb(12)

    refute_equal @game.bomb_positions, [10, 11, 12, 13, 14]
  end

  def test_that_reassign_bombs_preserves_the_number_of_total_bombs
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    @game.reassign_bomb(12)

    assert_equal @game.bomb_positions.length, 5
  end

  def test_that_reassign_bombs_can_update_cell_content
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    @game.reassign_bomb(12)

    refute_equal @game.board_positions[12].content, 'B'
  end

  def test_that_reassign_bombs_can_update_cell_values
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    @game.reassign_bomb(12)

    refute_equal @game.board_positions[12].value, 'B'
  end

  def test_that_if_first_move_is_a_bomb_it_gets_reassigned
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move = [2,2, "move"]

    @game.place_move(move)

    revealed = @game.board_positions.each_index.select{|i| @game.board_positions[i].status == 'revealed'}

    refute_equal(revealed, [5,6,15,16])
  end

  def test_that_if_second_move_has_greater_than_zero_value_it_only_reveals_itself
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move1 = [0,0, "move"]
    move2 = [4,3, "move"]

    @game.place_move(move1)
    @game.place_move(move2)

    revealed = @game.board_positions.each_index.select{|i| @game.board_positions[i].status == 'revealed'}

    assert_equal(revealed, [0,1,2,3,4,5,6,7,8,9,19])
  end

  def test_that_if_a_move_is_placed_on_a_flagged_square_the_flag_is_removed
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    move1 = [0,0, "move"]
    move2 = [4,3, "flag"]
    move3 = [4,3, "move"]

    @game.place_move(move1)
    @game.place_move(move2)
    @game.place_move(move3)

    assert_nil(@game.board_positions[19].flag)
  end

  def test_that_it_can_return_the_board_values
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    expected = [0, 0, 0, 0, 0, 2, 3, 3, 3, 2, 'B', 'B', 'B', 'B', 'B', 2, 3, 3, 3, 2, 0, 0, 0, 0, 0]
    assert_equal(expected, @game.board_values)
  end

  def test_that_it_can_return_the_boards_cell_status
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    to_reveal = [20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].update_cell_status }

    assert_equal(to_reveal, @game.board_cell_status)
  end

  def test_that_it_can_return_an_array_of_the_boards_flag_positions
    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)

    to_flag = [20,21,22,23,24]
    to_flag.each { |el|
      @game.board_positions[el].add_flag }

    assert_equal([20,21,22,23,24], @game.board_flags)
  end

  def test_that_it_can_set_the_status_of_an_array_of_cells_to_revealed

    bomb_positions = [10, 11, 12, 13, 14]
    positions = [ " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " ",
                  "B", "B", "B", "B", "B",
                  " ", " ", " ", " ", " ",
                  " ", " ", " ", " ", " " ]
    @game.set_bomb_positions(bomb_positions)
    @game.set_positions(positions)
    to_reveal = [20,21,22,23,24]

    result = @game.set_cell_status(to_reveal)

    assert_equal('revealed', @game.board_positions[21].status)
  end
end
