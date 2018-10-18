module Minesweeper
  class NeighboringCells
    def get_cells(positions, position, row_size, empty=false)
      positions_array = []; cells_hash = {}; offsets = [0, -1, +1]
      offsets.each do |row_offset|
        offsets.each do |cell_offset|
          unless current_cell?(row_offset, cell_offset)
            collect_row(cells_hash, position, row_size, row_size*row_offset, position+cell_offset)
          end
        end
      end
      empty ? empty_neighboring_cells(cells_hash, positions_array, row_size, positions) : all_neighboring_cells(cells_hash, positions_array, row_size)
    end

    def current_cell?(row_offset, cell_offset)
      row_offset.zero? && cell_offset.zero?
    end

    def collect_row(cells_hash, position, row_size, row_factor, row_neighbor)
      collect_cell(cells_hash, position, row_size, row_factor, row_neighbor)
    end

    def collect_cell(cells_hash, position, row_size, row_factor, row_neighbor)
      key = row_neighbor + row_factor
      row = (position / row_size).to_i * row_size + row_factor
      cells_hash[key] = row
    end

    def all_neighboring_cells(cells_hash, positions_array, row_size)
      cells_hash.each do |cell_position, cell_row|
        positions_array << cell_position if within_bounds(cell_position, cell_row, row_size)
      end
      positions_array
    end

    def empty_neighboring_cells(cells_hash, positions_array, row_size, positions)
      all_neighboring_cells(cells_hash, positions_array, row_size).select{|cell| is_empty?(cell, positions)}
    end

    private

    def is_empty?(position, positions)
      positions[position].content != 'B'
    end

    def within_bounds(relative_position, row, row_size)
      size = row_size**2
      (relative_position >= 0 && relative_position < size) && 
        (relative_position >= row && relative_position < row + row_size)
    end
  end
end
