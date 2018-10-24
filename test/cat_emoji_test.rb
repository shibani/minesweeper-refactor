require "test_helper"

class CatEmojiTest < Minitest::Test
  def setup
    @emoji = Minesweeper::CatEmoji.new
  end

  def test_that_it_can_return_a_lost_emoji
    assert_equal("\u{1f640} ", @emoji.show_lost_emoji)
  end

  def test_that_it_can_return_a_won_emoji
    assert_equal("\u{1f63a} ", @emoji.show_won_emoji)
  end

  def test_that_it_can_return_a_flag_emoji
    assert_equal("\u{1f364} ", @emoji.show_flag_emoji)
  end
end
