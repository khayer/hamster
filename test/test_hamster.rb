require "hamster"

class TestHamster < Test::Unit::TestCase

  def test_initialize
    k = Hamster.new()
    assert_equal(1,1)
  end

end
