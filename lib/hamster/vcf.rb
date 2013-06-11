class VCF

  def initialize(filename)
    @filehandle = File.open(filename)
    @scaffolds = Hash.new()
    @snp_start_pos = nil
  end

  attr_accessor :filehandle, :scaffolds, :snp_start_pos

  def start_pos_and_scaffolds()
    @filehandle.rewind()
    @filehandle.each do |line|
      line.chomp!
      if line =~ /^#CHROM/
        @snp_start_pos = @filehandle.pos
        break
      end
      # ##contig=<ID=gi|471435125|gb|APMT01237659.1|,length=1000>
      next unless line =~ /##contig=<ID=/
      fields = line.split(/##contig=<ID=/)[1].split(",")
      scaffold = fields[0]
      length = fields[1].gsub(/\D/,"").to_i
      @scaffolds[scaffold] = length
    end
    logger.info("Found #{@scaffolds.length} scaffolds in header.")
    logger.debug("Start point is at #{@snp_start_pos}.")
  end

  def count_snps_for_each_scaffold(duper_tissue_pos,wt_tissue_pos)
    unique_snps_per_scaffold = Hash.new()
    last_scaffold = ""
    count = 0
    @filehandle.pos = @snp_start_pos
    @filehandle.each do |line|
      line.chomp!
      fields = line.split("\t")
      scaffold = fields[0]
      unless scaffold == last_scaffold
        unless count == 0
          unique_snps_per_scaffold[last_scaffold] = count.to_f/@scaffolds[last_scaffold].to_f
          count = 0
        end
        last_scaffold = scaffold
      else
        duper = fields[duper_tissue_pos+8]
        next if duper =~ /\.\/\./ || duper =~ /^0\/0/
        duper = duper.split(":")
        wt = fields[wt_tissue_pos+8].split(":")
        next if duper[0] == wt[0]
        next if less_than_95(duper[1])
        count += 1
      end
    end
    unique_snps_per_scaffold
  end
end