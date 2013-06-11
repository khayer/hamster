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
        read_depth = duper[1].split(",")
        alt = read_depth[0].to_i
        ref = read_depth[1].to_i
        next if ref == 0
        wt = fields[wt_tissue_pos+8].split(":")
        next if duper[0] == wt[0]
        next if less_than_95(duper[1])
        count += 1
      end
    end
    unique_snps_per_scaffold
  end

  def count_snps_for_each_scaffold_100base_window(
      duper_tissue_pos,wt_tissue_pos,offset=false,
      window_length=500000)
    unique_snps_per_scaffold = Hash.new()
    last_scaffold = nil
    count = 0
    window_num = 0
    old_window_num = 0
    offset ? os = window_length/2 : os = 0
    @filehandle.pos = @snp_start_pos
    @filehandle.each do |line|
      line.chomp!
      fields = line.split("\t")
      scaffold = fields[0]
      last_scaffold = scaffold unless last_scaffold
      position = fields[1].to_i
      if @scaffolds[last_scaffold] > window_length
        divider = window_length.to_f
      else
        next #divider = @scaffolds[last_scaffold].to_f
      end
      while position > ((window_num + 1) * window_length + os)
        window_num += 1
      end
      if scaffold != last_scaffold
        logger.info("Scaffold is #{scaffold} at the moment")
        unless count == 0
          unique_snps_per_scaffold[[last_scaffold,old_window_num]] = count.to_f / divider
          count = 0
        end
        last_scaffold = scaffold
        window_num = 0
        old_window_num = window_num
      end
      if window_num != old_window_num
        unless count == 0
          unique_snps_per_scaffold[[last_scaffold,old_window_num]] = count.to_f / divider
          count = 0
        end
        old_window_num = window_num
      end
      duper = fields[duper_tissue_pos+8]
      next if duper =~ /\.\/\./ || duper =~ /^0\/0/
      duper = duper.split(":")
      read_depth = duper[1].split(",")
      alt = read_depth[0].to_i
      ref = read_depth[1].to_i
      next if ref == 0
      wt = fields[wt_tissue_pos+8].split(":")
      next if duper[0] == wt[0]
      next if less_than_95(duper[1])
      count += 1
    end
    unique_snps_per_scaffold
  end


  def visualize_high_scores(unique_snps,first=5,
    duper_tissue_pos,wt_tissue_pos)
    unique_snps_sorted = unique_snps.sort_by {
      |scaffold, value| value}
    visualized = []
    while first > 0
      name = unique_snps_sorted[-first][0][0]
      first -= 1
      puts visualized
      visualized.include?(name) ? next : visualized << name
      @filehandle.pos = @snp_start_pos
      data_x = []
      data_y = []
      @filehandle.each do |line|
        fields = line.split("\t")
        next unless fields[0] == name
        scaffold = fields[0]
        position = fields[1].to_i
        duper = fields[duper_tissue_pos+8]
        next if duper =~ /\.\/\./ || duper =~ /^0\/0/
        duper = duper.split(":")
        wt = fields[wt_tissue_pos+8].split(":")
        next if duper[0] == wt[0]
        read_depth = duper[1].split(",")
        alt = read_depth[0].to_i
        ref = read_depth[1].to_i
        next if ref == 0
        next if less_than_95(duper[1])
        data_x << position
        data_y << proportion(duper[1])
      end
      puts data_x.length
      puts data_y.length
      plot_data(data_x,data_y,name,@scaffolds[name])
    end
  end

end