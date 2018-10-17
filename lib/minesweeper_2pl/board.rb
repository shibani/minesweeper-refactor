module Minesweeper
  class Board
    attr_accessor :bomb_positions, :positions
    attr_reader :row_size, :bomb_count, :size

    def initialize(row_size, bomb_count, bomb_position_args=[])
      @row_size = row_size
      @bomb_count = bomb_count
      @size = @row_size ** 2
      assign_bomb_positions(bomb_position_args)
      set_positions(bomb_position_args)
    end

    def set_positions(bomb_position_args=[])
      assign_cell_content
      assign_values_to_all_positions
    end

    def assign_bomb_positions(bomb_position_args)
      if bomb_position_args != []
        self.bomb_positions = bomb_position_args 
      else
        bombs = (0..size - 1).to_a.shuffle
        self.bomb_positions = bombs.first(bomb_count)
      end
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
      cells_hash = {}

      set_left(cells_hash, position, row_size)
      set_right(cells_hash, position, row_size)

      set_bottom_left(cells_hash, position, row_size)
      set_bottom_middle(cells_hash, position, row_size)
      set_bottom_right(cells_hash, position, row_size)

      set_top_left(cells_hash, position, row_size)
      set_top_middle(cells_hash, position, row_size)
      set_top_right(cells_hash, position, row_size)


      if empty
        empty_neighboring_cells(cells_hash, positions_array)
      else 
        non_empty_neighboring_cells(cells_hash, positions_array)
      end
    end

    def set_left(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size
      cells_hash[position - 1] = row
    end 

    def set_right(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size
      cells_hash[position + 1] = row
    end 

    def set_bottom_left(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size - row_size
      cells_hash[position - row_size - 1] = row
    end

    def set_bottom_right(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size - row_size
      cells_hash[position - row_size + 1] = row
    end

    def set_bottom_middle(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size - row_size
      cells_hash[position - row_size] = row
    end

    def set_top_left(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size + row_size
      cells_hash[position + row_size - 1] = row
    end

    def set_top_middle(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size + row_size
      cells_hash[position + row_size] = row
    end

    def set_top_right(cells_hash, position, row_size)
      row = (position / row_size).to_i * row_size + row_size
      cells_hash[position + row_size + 1] = row
    end


    def empty_neighboring_cells(cells_hash, positions_array)
      cells_hash.each do |cell_position, cell_row|
        positions_array << cell_position if within_bounds(cell_position, cell_row) && is_empty?(cell_position)
      end
      positions_array
    end

    def non_empty_neighboring_cells(cells_hash, positions_array)
      cells_hash.each do |cell_position, cell_row|
        positions_array << cell_position if within_bounds(cell_position, cell_row)
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
