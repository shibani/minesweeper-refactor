module Minesweeper
  class CliBoardFormatter

    attr_accessor :show_bombs

    def format_board_with_emoji(board, emoji)
      board.positions.map do |cell|
        case show_bombs
        when 'won'
          render_won_view(cell, emoji)
        when 'show'
          render_lost_view(cell, emoji)
        else
          render_normal_view(cell, emoji)
        end
      end
    end

    private

    def render_lost_view(cell, emoji)
      return show_guessed_bomb if cell_is_a_bomb?(cell) && cell_is_a_flag?(cell)
      return emoji.show_lost_emoji if cell_is_a_bomb?(cell)
      return emoji.show_flag_emoji if cell_is_a_flag?(cell)
      cell_is_revealed?(cell) ? show_cell_value(cell) : show_empty
    end

    def render_won_view(cell, emoji)
      return emoji.show_won_emoji if cell_is_a_bomb?(cell)
      cell_is_revealed?(cell) ? show_cell_value(cell) : show_empty
    end

    def render_normal_view(cell, emoji)
      return emoji.show_flag_emoji if !cell_is_revealed?(cell) && cell_is_a_flag?(cell) 
      return show_cell_value(cell) if cell_is_revealed?(cell) && cell_is_an_integer?(cell)
      show_empty
    end

    def cell_is_revealed?(cell)
      cell.status == 'revealed'
    end

    def cell_is_a_bomb?(cell)
      cell.content == 'B'
    end

    def cell_is_a_flag?(cell)
      cell.flag == 'F'
    end

    def cell_is_an_integer?(cell)
      cell.value.is_a? Integer
    end

    def show_cell_value(cell)
      cell.value.to_s + ' '
    end

    def show_guessed_bomb
      'BF'
    end

    def show_empty
      '  '
    end
  end
end
