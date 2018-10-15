module Minesweeper
  class BoardPrinter

    NEWLINE = '\n'
    ALPHA_LEFT = '  '
    ALPHA_RIGHT = ' '
    CELL_LEFT = '|  '
    CELL_RIGHT = '  '
    CELL_END = '  |'
    CELL_DIVIDER = '+======'
    HEADER_CELL_LEFT = '   '
    HEADER_CELL_RIGHT = '  '
    INTRO = '     '

    def print_board(board_array, board)
      puts board_to_string(board_array, board)
    end

    def board_to_string(board_array, board)
      string = build_header(board)
      string += header_formatting
      string += build_rows(board_array, board)
    end

    private

    def header_formatting
      NEWLINE + ALPHA_LEFT + sprintf('%2s', 0.to_s) + ALPHA_RIGHT
    end

    def build_header(board)
      string = NEWLINE + INTRO
      board.row_size.to_i.times do |count|
        string += HEADER_CELL_LEFT + sprintf('%2s', (count).to_s) + HEADER_CELL_RIGHT
      end
      string += NEWLINE + INTRO
      board.row_size.to_i.times do
        string += CELL_DIVIDER
      end
      string += '+'
    end

    def build_rows(board_array, board)
      string = ''
      (0..board.row_size.to_i-1).to_a.each do |row|
        string += build_cell(board_array, row, board)
        string += build_row_divider(board, row)
      end
      string
    end

    def build_cell(board_array, row, board)
      string = ''
      (0..board.row_size.to_i-1).to_a.each do |col|
        if col == board.row_size - 1
          string += CELL_LEFT + get_cell_content(board_array, (row*board.row_size.to_i)+(col)) + CELL_END
        else
          string += CELL_LEFT + get_cell_content(board_array, (row*board.row_size.to_i)+(col)) + CELL_RIGHT
        end
      end
      string
    end

    def build_row_divider(board, row)
      string = NEWLINE + INTRO
      board.row_size.to_i.times do
        string += CELL_DIVIDER
      end
      string += '+'
      unless row == board.row_size - 1
        string += NEWLINE + ALPHA_LEFT + sprintf('%2s', (row+1).to_s) + ALPHA_RIGHT
      end
      string
    end

    def get_cell_content(cells, position)
      cells[position]
    end
  end
end
