require 'gnuplot'
module Functions

  def less_than_95(num_reads)
    num_reads = num_reads.split(",")
    num_reads_ref = num_reads[0].to_f
    num_reads_alt = num_reads[1].to_f
    (num_reads_alt/(num_reads_ref+num_reads_alt)) < 0.95
  end

  def proportion(num_reads)
    num_reads = num_reads.split(",")
    num_reads_ref = num_reads[0].to_f
    num_reads_alt = num_reads[1].to_f
    (num_reads_alt/(num_reads_ref+num_reads_alt))
  end

  def plot_data(data_x,data_y,name,length)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        filename = "test/data/" + name + ".png"
        plot.output filename
        plot.terminal 'png'
        plot.title "Unique SNP's for #{name}, length = #{length}"
        plot.ylabel "SNP's"
        plot.xlabel "position"
        plot.xtics 'nomirror'
        plot.ytics 'nomirror'
        #plot.xrange "[0:10]"
        plot.yrange "[0.6:1.1]"

        plot.data = [
          Gnuplot::DataSet.new( [data_x, data_y] ) do |ds|
            ds.with= "points lc 2"
            ds.notitle
          end
        ]
      end
    end
  end

end