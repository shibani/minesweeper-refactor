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
        board_positions[el].revealed_status
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
      board.bomb_positions = create_new_bomb_array(position)
      board.set_positions
    end

    def create_new_bomb_array(position)
      remove_bomb_from_bomb_array = game_utils.bomb_positions(board) - [position]
      new_bomb_location = (((0...board.row_size ** 2 ).to_a) - game_utils.bomb_positions(board)).sample
      remove_bomb_from_bomb_array << new_bomb_location
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

    def check_win_or_loss(io)
      return unless game_over
      is_won? ? process_game_over(io, 'won') : process_game_over(io, 'show')
    end

    def mark_move_on_board(position)
      if game_utils.first_move?(board) || not_the_first_move_but_position_has_zero_score(board, position)
        reassign_bomb(position) if game_utils.first_move?(board) && game_utils.position_is_a_bomb?(board, position)
        reveal_position_with_flood_fill(board, position)
      end
      revealed_status(board, position)
      game_utils.board_position_at(board, position).remove_flag unless game_utils.position_is_a_bomb?(board, position)
    end

    def not_the_first_move_but_position_has_zero_score(board, position)
      !game_utils.first_move?(board) && game_utils.position_has_a_zero_value?(board, position)
    end

    def reveal_position_with_flood_fill(board, position)
      game_utils.position_is_a_bomb?(board, position) ? self.game_over = true : flood_fill(position)
    end

    def flood_fill(position)
      result = board.show_adjacent_empties_with_value(position)
      cells_to_reveal = []
      result.each do |adj_position|
        adjacent_cell = game_utils.board_position_at(board, adj_position)
        cells_to_reveal << adj_position unless adjacent_cell.status == 'revealed' || adjacent_cell.flag == 'F'
        adjacent_cell.revealed_status unless adjacent_cell.flag == 'F'
      end
      cells_to_reveal + [position]
    end

    def mark_flag_on_board(position)
      game_utils.mark_flag(board, position)
    end

    def process_game_over(io, game_msg)
      formatter.show_bombs = game_msg if ['won', 'show'].include? game_msg
      #print_board(io)
      game_msg == 'won' ? 'win' : 'lose'
    end

    private

    def update_cell_content(board, array)
      array.each.with_index do |position, i|
        game_utils.board_position_at(board, i).update_cell_content(position)
      end
    end

    def update_cell_value(board)
      game_utils.board_positions(board).each.with_index do |position, i|
        value = board.assign_value(i)
        result = position.content == 'B' ? position.content : value
        position.update_cell_value(result)
      end
    end

    def revealed_status(board, position)
      game_utils.board_position_at(board, position).revealed_status
    end
  end
end
