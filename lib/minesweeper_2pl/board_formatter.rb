module Minesweeper
  class BoardFormatter

    attr_accessor :show_bombs

    def format_board_with_emoji(board, emoji)
      board.positions.map do |cell|
        if show_bombs == 'show'
          render_lost_view(cell, emoji)
        elsif show_bombs == 'won'
          render_won_view(cell, emoji)
        else
          render_normal_view(cell, emoji)
        end
      end
    end

    private

    def render_lost_view(cell, emoji)
      if cell_is_revealed?(cell)
        if cell_is_a_bomb?(cell) && cell_is_a_flag?(cell)
          show_guessed_bomb
        elsif cell_is_a_bomb?(cell)
          emoji.show_lost_emoji
        elsif cell_is_a_flag?(cell)
          emoji.show_flag_emoji
        else
          show_cell_value(cell)
        end
      else
        if cell_is_a_bomb?(cell) && cell_is_a_flag?(cell)
          show_guessed_bomb
        elsif cell_is_a_bomb?(cell)
          emoji.show_lost_emoji
        elsif cell_is_a_flag?(cell)
          emoji.show_flag_emoji
        else
          show_empty
        end
      end
    end

    def render_won_view(cell, emoji)
      if cell_is_revealed?(cell)
        if cell_is_a_bomb?(cell)
          emoji.show_won_emoji
        else
          show_cell_value(cell)
        end
      else
        if cell_is_a_bomb?(cell)
          emoji.show_won_emoji
        else
          show_empty
        end
      end
    end

    def render_normal_view(cell, emoji)
      if cell_is_revealed?(cell)
        if cell_is_a_flag?(cell)
          show_cell_value(cell)
        elsif cell.value.is_a? Integer
          show_cell_value(cell)
        else
          show_empty
        end
      else
        if cell_is_a_flag?(cell)
          emoji.show_flag_emoji
        else
          show_empty
        end
      end
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
