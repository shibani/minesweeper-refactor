module Minesweeper
  class Game
    attr_accessor :board, :game_over
    attr_reader :formatter, :board_printer, :icon_style

    def initialize(row_size, bomb_count=0, cat_emoji=nil, bomb_array=[])
      board = Board.new(row_size, bomb_count, bomb_array)
      self.board = board

      set_board_positions(row_size)

      @icon_style = cat_emoji ? CatEmoji.new : BombEmoji.new
      @formatter = BoardFormatter.new
      @board_printer = BoardPrinter.new
    end

    def row_size
      board.row_size
    end

    def bomb_count
      board.bomb_count
    end

    def set_bomb_positions(array)
      board.bomb_positions = array
    end

    def bomb_positions
      board.bomb_positions
    end

    def set_positions(array)
      array.each.with_index do |position, i|
        board_positions[i].update_cell_content(position)
      end
      board_positions.each.with_index do |position, i|
        content = board_positions[i].content
        if content == 'B'
          board_positions[i].update_cell_value(content)
        else
          value = board.assign_value(i)
          board_positions[i].update_cell_value(value)
        end
      end
    end

    def get_position(move)
      position = move_to_position(move)
      board_positions[position]
    end

    def set_board_positions(size)
      board.set_positions(size * size)
    end

    def board_positions
      board.positions
    end

    def board_values
      board_positions.map(&:value)
    end

    def set_board_values
      board.assign_values_to_all_positions
    end

    def set_cell_status(array)
      array.each do |el|
        board_positions[el].update_cell_status
      end
    end

    def board_cell_status
      board_positions.each_index.select{ |i| board_positions[i].status == 'revealed' }
    end

    def board_flags
      board_positions.each_index.select{ |i| board_positions[i].flag == 'F' }
    end

    def print_board
      board_array = formatter.format_board_with_emoji(board, icon_style)
      board_printer.print_board(board_array, board)
    end

    def reassign_bomb(position)
      new_bomb_array = bomb_positions - [position]
      new_bomb_location = (((0...row_size ** 2 ).to_a) - bomb_positions).sample
      new_bomb_array << new_bomb_location
      set_bomb_positions(new_bomb_array)
      board.set_positions(row_size ** 2)
    end

    def place_move(move)
      position = move_to_position(move)
      if move.last == 'move'
        if first_move?
          reassign_bomb(position) if position_is_a_bomb?(position)
          mark_move_on_board(position)
        else
          if position_has_a_non_zero_value?(position)
            reveal_self(position)
            board_positions[position].remove_flag unless position_is_a_bomb?(position)
          else
            mark_move_on_board(position)
            board_positions[position].remove_flag unless position_is_a_bomb?(position)
          end
        end
      elsif move.last == 'flag'
        mark_flag_on_board(position)
      end
      self.game_over = true if is_won?
    end

    def show_bombs=(msg)
      if msg == 'show'
        formatter.show_bombs = 'show'
      elsif msg == 'won'
        formatter.show_bombs = 'won'
      else
        formatter.show_bombs = false
      end
    end

    def is_won?
      all_bomb_positions_are_flagged?
    end

    def is_not_valid?(move=nil)
      move.nil? || get_position(move).status == 'revealed'
    end

    def gameloop_check_status
      print_board if game_over != true
      game_over
    end

    def check_win_or_loss
      if game_over
        if is_won?
          formatter.show_bombs = 'won'
          print_board
          result = 'win'
        else
          formatter.show_bombs = 'show'
          print_board
          result = 'lose'
        end
      end
      result
    end

    def mark_move_on_board(position)
      if position_is_a_bomb?(position)
        self.game_over = true
      else
        flood_fill(position)
      end
      board_positions[position].update_cell_status
    end

    def flood_fill(position)
      cells_to_reveal = []
      result = board.show_adjacent_empties_with_value(position)
      result.each do |adj_position|
        cells_to_reveal << adj_position unless board_positions[adj_position].status == 'revealed' || board_positions[adj_position].flag == 'F'
        board_positions[adj_position].update_cell_status unless board_positions[adj_position].flag == 'F'
      end
      cells_to_reveal + [position]
    end

    def reveal_self(position)
      board_positions[position].update_cell_status
    end

    def mark_flag_on_board(position)
      mark_flag(position)
    end

    private

    def move_to_position(move)
      if move.is_a? Array
        move[0] + board.row_size * move[1]
      else
        raise
      end
    end

    def position_to_move(position)
      [
        (position % board.row_size).to_i,
        (position / board.row_size).to_i
      ]
    end

    def position_is_a_bomb?(position)
      board.bomb_positions.include?(position)
    end

    def position_is_empty?(position)
      board_positions[position].content == ' '
    end

    def position_is_flag?(position)
      board_positions[position].flag == 'F'
    end

    def position_includes_a_flag?(position)
      board_positions[position].flag == 'F'
    end

    def position_has_a_zero_value?(position)
      (board_positions[position].value.is_a? Integer) && (board_positions[position].value == 0)
    end

    def position_has_a_non_zero_value?(position)
      (board_positions[position].value.is_a? Integer) && (board_positions[position].value > 0)
    end

    def mark_board(position, content)
      board_positions[position].update_cell_content(content)
    end

    def mark_flag(position)
      cell = board_positions[position]
      unless cell.status == 'revealed'
        if cell.flag == "F"
          cell.remove_flag
        elsif cell.flag.nil?
          cell.add_flag
        end
      end
    end

    def all_bomb_positions_are_flagged?
      board_flags.sort == bomb_positions.sort
    end

    def first_move?
      revealed = board_positions.select{|el| el.status == 'revealed'}
      revealed.empty?
    end
  end
end
