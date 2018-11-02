module Minesweeper
  class Board
    attr_accessor :bomb_positions, :positions
    attr_reader :row_size, :bomb_count, :size

    def initialize(row_size, bomb_count, bomb_position_args=[])
      @row_size = row_size
      @bomb_count = bomb_count
      @size = @row_size**2
      @neighboring_cells = NeighboringCells.new
      @adjacent_empties = AdjacentEmpties.new
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
      @neighboring_cells.get_cells(positions, position, row_size, empty)
    end

    def show_adjacent_empties_with_value(position)
      @adjacent_empties.get_empties_with_value(position, positions, row_size)
    end

    def assign_value(position)
      if is_empty?(position)
        sum = 0
        neighboring_cells(position).each { |cell_position| sum += check_position(cell_position)} 
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

    def check_position(position)
      positions[position].content == 'B' ? 1 : 0
    end
  end
end
