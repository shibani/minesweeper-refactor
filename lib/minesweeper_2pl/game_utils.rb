module Minesweeper
  class GameUtils

    def board_positions(board)
      board.positions
    end

    def board_values(board)
      board_positions(board).map(&:value)
    end

    def board_flags(board)
      board_positions(board).each_index.select{ |i| board_positions(board)[i].flag == 'F'}
    end

    def board_cell_status(board)
      board_positions(board).each_index.select{ |i| board_positions(board)[i].status == 'revealed'}
    end

    def is_not_valid?(board, move=nil)
      move.nil? || get_position(board, move).status == 'revealed'
    end

    def get_position(board, move)
      position = move_to_position(board, move)
      board.positions[position]
    end

    def move_to_position(board, move)
      if move.is_a? Array
        move[0] + board.row_size * move[1]
      else
        raise
      end
    end

    def position_to_move(board, position)
      [
        (position % board.row_size).to_i,
        (position / board.row_size).to_i
      ]
    end

    def board_position_at(board, position)
      board.positions[position]
    end

    def position_is_a_bomb?(board, position)
      board.bomb_positions.include?(position)
    end

    def position_is_empty?(board, position)
      board_position_at(board, position).content == ' '
    end

    def position_is_flag?(board, position)
      board_position_at(board, position).flag == 'F'
    end

    def position_includes_a_flag?(board, position)
      board_position_at(board, position).flag == 'F'
    end

    def position_has_a_zero_value?(board, position)
      (board_position_at(board, position).value.is_a? Integer) && (board_positions(board)[position].value == 0)
    end

    def position_has_a_non_zero_value?(board, position)
      (board_position_at(board, position).value.is_a? Integer) && (board_position_at(board, position).value > 0)
    end

    def mark_board(board, position, content)
      board_position_at(board, position).update_cell_content(content)
    end

    def mark_flag(board, position)
      cell = board_position_at(board, position)
      unless cell.status == 'revealed'
        if cell.flag == "F"
          cell.remove_flag
        elsif cell.flag.nil?
          cell.add_flag
        end
      end
    end

    def bomb_positions(board)
      board.bomb_positions
    end

    def all_bomb_positions_are_flagged?
      board_flags.sort == bomb_positions.sort
    end

    def first_move?(board)
      revealed = board_positions(board).select{|el| el.status == 'revealed'}
      revealed.empty?
    end
  end
end