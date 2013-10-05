require "test/unit"
require "hamster"

class TestFasta < Test::Unit::TestCase

  def test_initialize
    k = Fasta.new("/Volumes/kafka/hamster_unplaced.scaf.fa")
    assert_equal(k.index,{})
  end

  def test_create_index
    k = Fasta.new("/Volumes/kafka/hamster_unplaced.scaf.fa")
    k.create_index("/Volumes/kafka/hamster_unplaced.scaf.fa.fai")
    assert_equal(k.index["gi|472278457|gb|KB708136.1|"],[26256861,377796692])
  end

  def test_sequence
    k = Fasta.new("/Volumes/kafka/hamster_unplaced.scaf.fa")
    k.create_index("/Volumes/kafka/hamster_unplaced.scaf.fa.fai")
    k.sequence("gi|472271995|gb|KB714598.1|")
    #seq = k.sequence("gi|472278355|gb|KB708238.1|")
    #puts seq[6173276,6173387]
  end

  #def test_part_sequences
  #  k = Fasta.new("hamster_unplaced.scaf.fa")
  #  k.create_index("hamster_unplaced.scaf.fa.fai")
  #  n = k.part_sequences(["gi|472278340|gb|KB708253.1|:4915575-4915778","gi|472278340|gb|KB708253.1|:4915126-4915777","gi|472278340|gb|KB708253.1|:1915126-2915777"])
  #end

end