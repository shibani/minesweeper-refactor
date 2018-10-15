module Minesweeper
  class Cell
    attr_reader :content, :value, :status, :flag

    def initialize(content)
      @content = content
      @flag = nil
    end

    def update_cell_content(content)
      @content = content
    end

    def update_cell_value(value)
      @value = value
    end

    def update_cell_status
      @status = 'revealed'
    end

    def add_flag
      @flag = 'F'
    end

    def remove_flag
      @flag = nil
    end
  end
end
