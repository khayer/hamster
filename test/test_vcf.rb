require "test/unit"
require "hamster"

class TestVCF < Test::Unit::TestCase

  def setup
    @test_long = "test/data/hamster.vcf"
    @test_short = "test/data/test.vcf"
    @test_idx = "test/data/hamster.vcf.idx"
  end

  #def test_initialize
  #  k = VCF.new(@test_short)
  #  assert_kind_of( File, k.filehandle )
  #  assert_equal(k.scaffolds,{})
  #  assert_equal(k.snp_start_pos,nil)
  #end
#
  #def test_start_pos_and_scaffolds()
  #  k = VCF.new(@test_short)
  #  k.start_pos_and_scaffolds
  #  assert_equal(k.scaffolds["gi|471435341|gb|APMT01237443.1|"],1028)
  #  assert_equal(k.snp_start_pos,1230595)
  #end
#
  #def test_start_pos_and_scaffolds_long()
  #  k = VCF.new(@test_long)
  #  k.start_pos_and_scaffolds
  #  assert_equal(k.scaffolds["gi|471435341|gb|APMT01237443.1|"],1028)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(k.scaffolds["gi|471435121|gb|APMT01237663.1|"],1626)
  #  assert_equal(k.scaffolds["gi|471435867|gb|APMT01236917.1|"],1032)
  #  assert_equal(k.snp_start_pos,1230595)
  #end
#
  #def test_count_snps_for_each_scaffold()
  #  k = VCF.new(@test_short)
  #  k.start_pos_and_scaffolds
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold(2,5)
  #  assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(unique_snps_per_scaffold["gi|472278466|gb|KB708127.1|"],1.816007827006267e-05)
  #  unique_snps_per_scaffold_sorted = unique_snps_per_scaffold.sort_by {|scaffold, value| value}
  #  assert_equal(unique_snps_per_scaffold_sorted[0],["gi|472278462|gb|KB708131.1|", 1.124978169101596e-05])
  #  assert_equal(unique_snps_per_scaffold_sorted[-1], ["gi|472278466|gb|KB708127.1|", 1.816007827006267e-05])
  #end

  #def test_count_snps_for_each_scaffold()
  #  k = VCF.new(@test_long)
  #  k.start_pos_and_scaffolds
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold(2,5)
  #  assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(unique_snps_per_scaffold["gi|472278466|gb|KB708127.1|"],1.8197676775797793e-05)
  #  unique_snps_per_scaffold_sorted = unique_snps_per_scaffold.sort_by {|scaffold, value| value}
  #  assert_equal(unique_snps_per_scaffold_sorted[0],["gi|472278210|gb|KB708383.1|", 9.749429902086476e-07])
  #  assert_equal(unique_snps_per_scaffold_sorted[-1], ["gi|471435867|gb|APMT01236917.1|", 0.011627906976744186])
  #end

  #def test_count_snps_for_each_scaffold_100base_window()
  #  k = VCF.new(@test_short)
  #  k.start_pos_and_scaffolds
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold_100base_window(2,5)
  #  assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(unique_snps_per_scaffold[["gi|472278466|gb|KB708127.1|",0]],1.8e-05)
  #  unique_snps_per_scaffold_sorted = unique_snps_per_scaffold.sort_by {|scaffold, value| value}
  #  assert_equal(unique_snps_per_scaffold_sorted[0],[["gi|472278464|gb|KB708129.1|", 64], 2.0e-06])
  #  assert_equal(unique_snps_per_scaffold_sorted[-1], [["gi|472278466|gb|KB708127.1|", 3], 0.000142])
#
  #  # With offset
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold_100base_window(2,5,true)
  #  assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(unique_snps_per_scaffold[["gi|472278466|gb|KB708127.1|",0]],2.0e-05)
  #  unique_snps_per_scaffold_sorted = unique_snps_per_scaffold.sort_by {|scaffold, value| value}
  #  assert_equal(unique_snps_per_scaffold_sorted[0],[["gi|472278464|gb|KB708129.1|", 47], 2.0e-06])
  #  assert_equal(unique_snps_per_scaffold_sorted[-1], [["gi|472278465|gb|KB708128.1|", 22], 0.000168])
  #end

  #def test_count_snps_for_each_scaffold_100base_window_long()
  #  k = VCF.new(@test_long)
  #  k.start_pos_and_scaffolds
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold_100base_window(2,5)
  #  assert_equal(unique_snps_per_scaffold["gi|471435341|gb|APMT01237443.1|"],nil)
  #  ##contig=<ID=gi|471435121|gb|APMT01237663.1|,length=1626>
  #  assert_equal(unique_snps_per_scaffold[["gi|472278466|gb|KB708127.1|",0]],1.8e-05)
  #  unique_snps_per_scaffold_sorted = unique_snps_per_scaffold.sort_by {|scaffold, value| value}
  #  assert_equal(unique_snps_per_scaffold_sorted[0],[["gi|472278350|gb|KB708243.1|", 10], 2.0e-06])
  #  assert_equal(unique_snps_per_scaffold_sorted[-1], [["gi|471435867|gb|APMT01236917.1|", 0], 0.011627906976744186])
  #end

  #def test_visualize_high_scores()
  #  k = VCF.new(@test_long)
  #  k.start_pos_and_scaffolds
  #  unique_snps_per_scaffold = k.count_snps_for_each_scaffold_100base_window(2,5)
  #  k.visualize_high_scores(unique_snps_per_scaffold,5,2,5)
#
  #end

  def test_count_snps_for_each_scaffold_sliding_window()
    k = VCF.new(@test_long)
    k.start_pos_and_scaffolds
    #k.count_snps_for_each_scaffold(1,4)
    #puts k.scaffolds
    unique_snps_per_scaffold = k.count_snps_for_each_scaffold_sliding_window(1,4)
    k.visualize_high_scores_snp(unique_snps_per_scaffold,1,4,5)
  end

  def teardown

  end


end