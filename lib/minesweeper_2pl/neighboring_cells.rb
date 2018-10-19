module Minesweeper
  class NeighboringCells
    def get_cells(positions, position, row_size, empty=false)
      positions_array = []; cells_hash = {}; offsets = [0, -1, +1]
      args_hash = {
        positions_array: [],
        positions: positions,
        position: position,
        row_size: row_size
      }
      offsets.each do |row_offset|
        offsets.each do |cell_offset|
          unless current_cell?(row_offset, cell_offset)
            collect_row(cells_hash, row_size*row_offset, position+cell_offset, args_hash)
          end
        end
      end
      empty ? empty_neighboring_cells(cells_hash, args_hash) : all_neighboring_cells(cells_hash, args_hash)
    end

    def current_cell?(row_offset, cell_offset)
      row_offset.zero? && cell_offset.zero?
    end

    def collect_row(cells_hash, row_factor, row_neighbor, args_hash)
      collect_cell(cells_hash, row_factor, row_neighbor, args_hash)
    end

    def collect_cell(cells_hash, row_factor, row_neighbor, args_hash)
      key = row_neighbor + row_factor
      row = (args_hash[:position] / args_hash[:row_size]).to_i * args_hash[:row_size] + row_factor
      cells_hash[key] = row
    end

    def all_neighboring_cells(cells_hash, args_hash)
      cells_hash.each do |cell_position, cell_row|
        args_hash[:positions_array] << cell_position if within_bounds(cell_position, cell_row, args_hash[:row_size])
      end
      args_hash[:positions_array]
    end

    def empty_neighboring_cells(cells_hash, args_hash)
      all_neighboring_cells(cells_hash, args_hash).select{|cell| is_empty?(cell, args_hash[:positions])}
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
