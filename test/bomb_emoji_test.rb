require "test_helper"

class BombEmojiTest < Minitest::Test
  def setup
    @emoji = Minesweeper::BombEmoji.new
  end

  def test_that_it_can_return_a_lost_emoji
    assert_equal("\u{1f4a3} ", @emoji.show_lost_emoji)
  end

  def test_that_it_can_return_a_won_emoji
    assert_equal("\u{1f3c6} ", @emoji.show_won_emoji)
  end

  def test_that_it_can_return_a_flag_emoji
    assert_equal("\u{1f6a9} ", @emoji.show_flag_emoji)
  end
end
