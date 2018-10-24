require 'test_helper' 

class InputTest < Minitest::Test
  def test_that_it_can_get_input
    @input = Minesweeper::Input.new
    
    io = StringIO.new
    io.puts "16\n"
    io.rewind
    $stdin = io

    result = @input.get_input
    $stdin = STDIN

    assert_equal("16", result)
  end
end