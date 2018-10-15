require 'stringio'

module IoTestHelpers
  def simulate_stdin(*inputs, &block)
    io = StringIO.new
    inputs.flatten.each { |str| io.puts(str) }
    io.rewind

    actual_stdin, $stdin = $stdin, io
    yield
  ensure
    $stdin = actual_stdin
  end
end

def assert_matched_arrays expected, actual
  assert_equal expected.to_ary.sort, actual.to_ary.sort
end
