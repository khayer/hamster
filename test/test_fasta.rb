require "test/unit"
require "hamster"

class TestFasta < Test::Unit::TestCase

  def test_initialize
    k = Fasta.new("hamster_unplaced.scaf.fa")
    assert_equal(k.index,{})
  end

  def test_create_index
    k = Fasta.new("hamster_unplaced.scaf.fa")
    k.create_index("hamster_unplaced.scaf.fa.fai")
    assert_equal(k.index["gi|472278457|gb|KB708136.1|"],[26256861,377796692])
  end

  def test_sequence
    k = Fasta.new("hamster_unplaced.scaf.fa")
    k.create_index("hamster_unplaced.scaf.fa.fai")
    #k.sequence("gi|472278457|gb|KB708136.1|")
    k.sequence("gi|471435121|gb|APMT01237663.1|")
  end

end