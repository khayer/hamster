module Functions

  def less_than_95(num_reads)
    num_reads = num_reads.split(",")
    num_reads_ref = num_reads[0].to_f
    num_reads_alt = num_reads[1].to_f
    (num_reads_alt/(num_reads_ref+num_reads_alt)) < 0.95
  end

  def sort_hash_by_value(some_hash)

  end

end