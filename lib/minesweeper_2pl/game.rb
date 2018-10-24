module Minesweeper
  class Game
    attr_accessor :game_over
    attr_reader :board, :formatter, :board_printer, :icon_style, :game_utils

    def initialize(board, cat_emoji=nil)
      @board = board
      @game_utils = GameUtils.new
      @icon_style = cat_emoji ? CatEmoji.new : BombEmoji.new
      @formatter = BoardFormatter.new
      @board_printer = BoardPrinter.new
    end

    def get_position(move)
      game_utils.get_position(board, move)
    end

    def board_positions
      game_utils.board_positions(board)
    end

    def board_values
      game_utils.board_values(board)
    end

    def set_cell_status(array)
      array.each do |el|
        board_positions[el].update_cell_status
      end
    end

    def board_cell_status
      game_utils.board_cell_status(board)
    end

    def board_flags
      game_utils.board_flags(board)
    end

    def print_board(io)
      board_array = formatter.format_board_with_emoji(board, icon_style)
      board_printer.print_board(board_array, board, io)
    end

    def set_positions(array)
      update_cell_content(board, array)
      update_cell_value(board)
    end

    def reassign_bomb(position)
      new_bomb_array = game_utils.bomb_positions(board) - [position]
      new_bomb_location = (((0...board.row_size ** 2 ).to_a) - game_utils.bomb_positions(board)).sample
      new_bomb_array << new_bomb_location
      board.bomb_positions = new_bomb_array
      board.set_positions
    end

    def place_move(move)
      position = game_utils.move_to_position(board, move)
      mark_move_on_board(position) if move.last == 'move'
      mark_flag_on_board(position) if move.last == 'flag'
      self.game_over = true if is_won?
    end

    def is_won?
      game_utils.board_flags(board).sort == game_utils.bomb_positions(board).sort
    end

    def is_not_valid?(move=nil)
      game_utils.is_not_valid?(board, move)
    end

    def gameloop_check_status(io)
      print_board(io) if game_over != true
      game_over
    end

    def check_win_or_loss(io)
      if game_over && is_won?
        set_print_format('won') 
        result = 'win'
      elsif game_over && !is_won?
        set_print_format('show')
        result = 'lose'
      end
      print_board(io)
      result
    end

    def mark_move_on_board(position)
      if game_utils.first_move?(board)
        reassign_bomb(position) if game_utils.position_is_a_bomb?(board, position)
        if game_utils.position_is_a_bomb?(board, position)
          self.game_over = true
        else
          flood_fill(position)
        end
        update_cell_status(board, position)
      else
        if game_utils.position_has_a_non_zero_value?(board, position)
          reveal_self(position)
          game_utils.board_position_at(board, position).remove_flag unless game_utils.position_is_a_bomb?(board, position)
        else
          if game_utils.position_is_a_bomb?(board, position)
            self.game_over = true
          else
            flood_fill(position)
          end
          update_cell_status(board, position)
          board_positions[position].remove_flag unless game_utils.position_is_a_bomb?(board, position)
        end
      end
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
      game_utils.board_position_at(board, position).update_cell_status
    end

    def mark_flag_on_board(position)
      game_utils.mark_flag(board, position)
    end

    def set_print_format(msg)
      if ['won', 'show'].include? msg
        formatter.show_bombs = msg
      else
        formatter.show_bombs = false 
      end
    end

    private

    def update_cell_content(board, array)
      array.each.with_index do |position, i|
        game_utils.board_position_at(board, i).update_cell_content(position)
      end
    end

    def update_cell_value(board)
      game_utils.board_positions(board).each.with_index do |position, i|
        if position.content == 'B'
          position.update_cell_value(position.content)
        else
          value = board.assign_value(i)
          position.update_cell_value(value)
        end
      end
    end

    def update_cell_status(board, position)
      game_utils.board_position_at(board, position).update_cell_status
    end
  end
end
