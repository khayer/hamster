require "test/unit"
require "hamster"

class TestVCF < Test::Unit::TestCase

  def setup
    @test_long = "test/data/hamster.vcf"
    @test_short = "test/data/test.vcf"
    @test_idx = "test/data/hamster.vcf.idx"
  end

  def test_initialize
    k = VCF.new(@test_short)
    assert_kind_of( File, k.filehandle )
    assert_equal(k.scaffolds,{})
    assert_equal(k.snp_start_pos,nil)
  end

  def test_start_pos_and_scaffolds()
    k = VCF.new(@test_short)
    k.start_pos_and_scaffolds
    assert_equal(k.scaffolds["gi|471435341|gb|APMT01237443.1|"],1028)
    assert_equal(k.snp_start_pos,1230595)
  end

  def test_start_pos_and_scaffolds_long()
    k = VCF.new(@test_long)
    k.start_pos_and_scaffolds
    assert_equal(k.scaffolds["gi|471435341|gb|APMT01237443.1|"],1028)
    ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
    assert_equal(k.scaffolds["gi|471435121|gb|APMT01237663.1|"],1626)
    assert_equal(k.snp_start_pos,1230595)
  end

  def test_count_snps_for_each_scaffold()
    k = VCF.new(@test_short)
    k.start_pos_and_scaffolds
    unique_snps_per_scaffold = k.count_snps_for_each_scaffold(2,5)
    assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
    ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
    assert_equal(unique_snps_per_scaffold["gi|472278466|gb|KB708127.1|"],1.8197676775797793e-05)
  end

  def teardown

  end


end