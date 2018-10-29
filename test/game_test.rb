require 'test_helper' 

class GameTest < Minitest::Test

  def setup
    @board = Minesweeper::Board.new(5,5,[10,11,12,13,14])
    @mock_game = Minesweeper::MockGame.new(@board, {}, nil)
    @mock_io = { output: Minesweeper::MockOutput.new, input: "test" }
    @test_io = { 
      output: Minesweeper::Output.new, 
      input: "test",
      board_printer: Minesweeper::BoardPrinter.new,
      board_formatter: Minesweeper::CliBoardFormatter.new
    }
    @game = Minesweeper::Game.new(@board, @test_io, nil)
  end

  def test_that_it_has_a_game_class
    refute_nil @game
  end

  def test_that_initialize_sets_a_board_to_belong_to_the_game
    refute_nil @game.board
  end

  def test_that_initialize_can_create_a_new_boardcli
    refute_nil @game.formatter
  end

  def test_that_initialize_creates_the_icon_style
    refute_nil @game.icon_style
  end

  def test_that_initialize_creates_the_icon_style_2
    assert @game.icon_style.instance_of?(Minesweeper::BombEmoji)
  end

  def test_that_set_positions_sets_the_value_of_every_position
    positions = ' , , , , , , , , , ,B,B,B,B, , '.split(",")
    bomb_positions = [10, 11, 12, 13]
    board = Minesweeper::Board.new(4,4,bomb_positions)
    game = Minesweeper::Game.new(board, {})
    game.set_positions(positions)

    result = game.board_positions.map{|cell| cell.value}
    game.set_positions(result)
    expected_positions = [
      0, 0, 0, 0,
      0, 1, 2, 2,
      2, 3, 'B', 'B',
      'B', 'B', 3, 2
    ]

    assert_equal(expected_positions, result)
  end

  def test_that_it_can_print_the_board
    @mock_game.set_input!("printed board goes here")

    out, err = capture_io do
      @mock_game.print_board(@test_io)
    end
    assert_equal "printed board goes here", out
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

  def test_that_it_can_get_the_games_board_positions
    result = @game.board_positions

    assert_equal 25, result.size
  end

  def test_that_it_can_access_position_by_coordinates
    bomb_positions = [13, 15, 16, 18, 19]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    move = [3,3, 'move']

    assert_equal 'B', @game.get_position(move).content
  end

  def test_that_it_can_place_a_move_on_the_board
    bomb_positions = [13, 15, 16, 18, 19]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [0, 0, 'move']

    @game.place_move(move)

    assert_equal 'revealed', @game.get_position(move).status
  end

  def test_that_it_can_set_the_game_to_game_over
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [10, 11, 12, 13, 14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    move = [3, 2, 'move']

    @game.place_move(move)

    assert @game.game_over
  end

  def test_that_it_can_set_a_flag
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [0,1, 'flag']

    @game.place_move(move)

    assert_equal 'F', @game.get_position(move).flag
  end

  def test_that_it_can_remove_a_flag
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [1,2, 'flag']

    @game.place_move(move)
    @game.place_move(move)

    assert_nil @game.get_position(move).flag
  end

  def test_that_it_can_check_if_a_game_is_over_1
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    move = [2,2, 'flag']

    @game.place_move(move)

    assert @game.is_won?
  end

  def test_that_it_can_check_if_a_game_is_over_2
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
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
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    move = [0,1, 'flag']

    @game.place_move(move)

    refute @game.game_over
  end

  def test_that_it_can_set_the_formatters_show_bombs_attribute
    @game.process_game_over('show')

    assert_equal('show', @game.formatter.show_bombs)
  end

  def test_that_it_can_turn_off_the_formatters_show_bombs_attribute
    @game.process_game_over('random string')

    refute @game.formatter.show_bombs
  end

  def test_that_it_can_set_the_formatters_show_bombs_attribute_to_won
    @game.process_game_over('won')

    assert_equal("won", @game.formatter.show_bombs)
  end

  def test_that_it_can_check_if_a_game_is_won
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [10,11,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    move = [2,2, "flag"]

    @game.place_move(move)

    assert(@game.is_won?)
  end

  def test_that_it_can_check_if_the_game_is_won
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [10,11,12,13,14]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }

    assert(@game.is_won?)
  end

  def test_that_it_can_check_if_the_game_is_not_won
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    to_reveal =  [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    refute(@game.is_won?)
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

    assert(@game.is_not_valid?(move))
  end

  def test_that_it_can_check_if_the_game_is_won_or_lost
    bomb_positions = [10, 11, 12, 13, 14]
    board = Minesweeper::Board.new(5, 5, bomb_positions)
    mock_game = Minesweeper::MockGame.new(@board, @test_io)
    bomb_positions.each { |flag| mock_game.mark_flag_on_board(flag) }
    mock_game.game_over = true

    assert_equal("win", mock_game.check_win_or_loss)
  end

  def test_that_it_can_check_if_the_game_is_won_or_lost_2
    bomb_positions = [10, 11, 12, 13, 14]
    board = Minesweeper::Board.new(5, 5, bomb_positions)
    mock_game = Minesweeper::MockGame.new(board, @test_io)
    move = [0,2, 'move']

    mock_game.place_move(move)
    mock_game.game_over = true

    assert_equal('lose', mock_game.check_win_or_loss)
  end

  def test_that_if_a_game_is_lost_all_its_bomb_positions_are_set_to_revealed
    bomb_positions = [10, 11, 12, 13, 14]
    board = Minesweeper::Board.new(5, 5, bomb_positions)
    mock_game = Minesweeper::MockGame.new(board, @test_io)
    mock_game.mark_flag_on_board(10)
    mock_game.mark_flag_on_board(11)
    move = [0,2, 'move']

    mock_game.place_move(move)
    mock_game.game_over = true
    mock_game.check_win_or_loss

    assert_equal('revealed', mock_game.board_positions[10].status)
  end

  def test_that_it_sets_a_square_to_revealed_after_marking_a_move
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    @game.mark_move_on_board(9)

    assert_equal('revealed', @game.board_positions[9].status)
  end


  def test_that_revealed_cells_have_revealed_status
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
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
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    result = @game.mark_flag_on_board(16)
    assert_equal('F', result)
  end

  def test_that_it_doesnt_mark_a_flag_if_position_is_revealed
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    to_reveal = [0,1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }

    @game.mark_flag_on_board(4)

    assert_nil @game.board_positions[4].flag
    assert 'revealed', @game.board_positions[4].status
  end

  def test_that_it_marks_a_flag_if_position_contains_an_integer
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    @game.mark_flag_on_board(4)

    assert_equal('F', @game.board_positions[4].flag)
  end

  def test_that_flood_fill_returns_adjacent_empties_1
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    to_reveal = [20,21,22,23,24]
    to_reveal.each { |el|
      @game.board_positions[el].revealed_status }
    result = @game.flood_fill(9)

    assert_equal([8,3,4,2,7,1,6,0,5,9].sort, result.sort)
  end

  def test_that_flood_fill_returns_adjacent_empties_when_position_is_a_bomb
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    result = @game.flood_fill(10)

    assert_equal([5,6,15,16,10], result)
  end

  def test_that_flood_fill_does_not_return_flagged_positions
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    flags = [5,6]
    flags.each { |fl| @game.mark_flag_on_board(fl) }
    result = @game.flood_fill(10)

    assert_equal([15,16,10], result)
  end

  def test_that_reassign_bombs_can_prevent_first_move_from_ending_the_game
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [2,2, "move"]

    @game.place_move(move)

    refute @game.game_over
  end

  def test_that_reassign_bombs_can_update_the_bombs_positions_array
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    @game.reassign_bomb(12)

    refute_equal @game.board.bomb_positions, [10, 11, 12, 13, 14]
  end

  def test_that_reassign_bombs_preserves_the_number_of_total_bombs
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    @game.reassign_bomb(12)

    assert_equal @game.board.bomb_positions.length, 5
  end

  def test_that_reassign_bombs_can_update_cell_content
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    @game.reassign_bomb(12)

    refute_equal @game.board_positions[12].content, 'B'
  end

  def test_that_reassign_bombs_can_update_cell_values
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})

    @game.reassign_bomb(12)

    refute_equal @game.board_positions[12].value, 'B'
  end

  def test_that_if_first_move_is_a_bomb_it_gets_reassigned
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move = [2,2, "move"]

    @game.place_move(move)

    revealed = @game.board_positions.each_index.select{|i| @game.board_positions[i].status == 'revealed'}

    refute_equal(revealed, [5,6,15,16])
  end

  def test_that_if_second_move_has_greater_than_zero_value_it_only_reveals_itself
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    move1 = [0,0, "move"]
    move2 = [4,3, "move"]

    @game.place_move(move1)
    @game.place_move(move2)

    revealed = @game.board_positions.each_index.select{|i| @game.board_positions[i].status == 'revealed'}

    assert_equal(revealed, [0,1,2,3,4,5,6,7,8,9,19])
  end

  def test_that_if_a_move_is_placed_on_a_flagged_square_the_flag_is_removed
    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
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

  def test_that_it_can_set_the_status_of_an_array_of_cells_to_revealed

    bomb_positions = [10, 11, 12, 13, 14]
    @board = Minesweeper::Board.new(5, 5, bomb_positions)
    @game = Minesweeper::Game.new(@board, {})
    to_reveal = [20,21,22,23,24]

    result = @game.set_cell_status(to_reveal)

    assert_equal('revealed', @game.board_positions[21].status)
  end
end
