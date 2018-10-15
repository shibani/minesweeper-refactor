module Minesweeper
  class Board
    attr_accessor :bomb_positions, :positions
    attr_reader :row_size, :bomb_count, :size

    def initialize(row_size, bomb_count, bomb_positions=[])
      @row_size = row_size
      @bomb_count = bomb_count
      @size = row_size * row_size
      assign_bomb_positions(bomb_positions)
      set_positions('foo')
    end

    def set_positions(foo)
      assign_cell_content
      assign_values_to_all_positions
    end

    def assign_bomb_positions(bomb_positions=[])
      return self.bomb_positions = bomb_positions if bomb_positions != []
      bombs = (0..size - 1).to_a.shuffle
      self.bomb_positions = bombs.first(bomb_count)
    end

    def assign_cell_content
      self.positions = (0...size).map do |cell|
        bomb_positions.include?(cell) ? Cell.new('B') : Cell.new(' ')
      end
    end

    def assign_values_to_all_positions
      positions.each.with_index do |cell, i|
        value = cell.content == 'B' ? 'B' : assign_value(i)
        cell.update_cell_value(value)
      end
    end

    def neighboring_cells(position, empty=false)
      positions_array = []

      middle_row = (position / row_size).to_i * row_size
      bottom_row = (position / row_size).to_i * row_size - row_size
      top_row = (position / row_size).to_i * row_size + row_size

      left = position - 1
      right = position + 1
      top = position + row_size
      bottom = position - row_size

      bottom_left = position - row_size - 1
      bottom_right = position - row_size + 1

      top_left = position + row_size - 1
      top_right = position + row_size + 1

      cells_hash = {}

      cells_hash[left] = middle_row
      cells_hash[right] = middle_row

      cells_hash[bottom_left] = bottom_row
      cells_hash[bottom] = bottom_row
      cells_hash[bottom_right] = bottom_row

      cells_hash[top_left] = top_row
      cells_hash[top] = top_row
      cells_hash[top_right] = top_row

      if empty
        cells_hash.each do |cell_position, cell_row|
          positions_array << cell_position if within_bounds(cell_position, cell_row) && is_empty?(cell_position)
        end
      else
        cells_hash.each do |cell_position, cell_row|
          positions_array << cell_position if within_bounds(cell_position, cell_row)
        end
      end
      positions_array
    end

    def show_adjacent_empties_with_value(position)
      spaces_to_clear = [position]
      cells_to_check = [position]
      checked = []

      while cells_to_check.length.positive?
        cell = cells_to_check.first
        neighboring_cells(cell).each do |cell_position|
          spaces_to_clear << cell_position unless positions[cell_position].content.include? 'B'
          cells_to_check << cell_position if positions[cell_position].value == 0
        end
        if checked.empty?
          cells_to_check = cells_to_check.uniq
        else
          cells_to_check = cells_to_check.uniq - checked
        end
        spaces_to_clear = spaces_to_clear.uniq
        checked << cell
      end
      spaces_to_clear - [position]
    end

    def assign_value(position)
      if is_empty?(position)
        cells_to_check = neighboring_cells(position)
        sum = 0
        cells_to_check.each do |cell_position|
          sum += check_position(cell_position)
        end
      end
      sum
    end

    def is_empty?(position)
      positions[position].content != 'B'
    end

    def all_positions_empty?
      !!(positions.detect { |position| position.status == 'revealed' }).nil?
    end

    private

    def within_bounds(relative_position, row)
      relative_position >= 0 && relative_position < size && relative_position >= row && relative_position < row + row_size
    end

    def check_position(position)
      positions[position].content == 'B' ? 1 : 0
    end
  end
end
