module Minesweeper
  class AdjacentEmpties

    def initialize
      @neighboring_cells = NeighboringCells.new
    end

    def get_empties_with_value(position, positions, row_size)
      args_hash = {
        spaces_to_clear: [position],
        cells_to_check: [position],
        checked: [],
        positions: positions,
        row_size: row_size
      }
      spaces_to_clear = cells_to_check_loop(args_hash)
      spaces_to_clear - [position]
    end

    def cells_to_check_loop(args_hash)
      while args_hash[:cells_to_check].length.positive?
        cell = args_hash[:cells_to_check].first
        args_hash[:spaces_to_clear] = collect_spaces_to_clear(cell, args_hash).uniq
        args_hash[:cells_to_check] = dedupe_cells_to_check(
          args_hash[:checked], collect_cells_to_check(cell, args_hash)
        )
        args_hash[:checked] << cell
      end
      args_hash[:spaces_to_clear]
    end

    def collect_spaces_to_clear(cell, args_hash)
      @neighboring_cells.get_cells(args_hash[:positions], cell, args_hash[:row_size]).each do |cell_position|
        args_hash[:spaces_to_clear] << cell_position unless args_hash[:positions][cell_position].content.include? 'B'
      end
      args_hash[:spaces_to_clear]
    end

    def collect_cells_to_check(cell, args_hash)
      @neighboring_cells.get_cells(args_hash[:positions], cell, args_hash[:row_size]).each do |cell_position|
        args_hash[:cells_to_check] << cell_position if args_hash[:positions][cell_position].value == 0
      end
      args_hash[:cells_to_check]
    end

    def dedupe_cells_to_check(checked, cells_to_check)
      if checked.empty?
        cells_to_check.uniq
      else
        cells_to_check.uniq - checked
      end
    end
  end
end