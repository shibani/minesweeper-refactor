require 'test_helper' 

class OutputTest < Minitest::Test
  def test_that_it_can_display_a_message
    @output = Minesweeper::Output.new
    
    out, _err = capture_io do
      @output.display("Hello World")
    end

    assert_equal("Hello World", out)
  end
end