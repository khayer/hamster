class Fasta
  #adding some comment
  def initialize(filename)
    @filehandle = File.open(filename)
    # @index[scaffold_name] = [scaffold_length,scaffold_offset]
    @index = Hash.new()
  end

  attr_accessor :filehandle, :index

  def create_index(index_file)
    # .fai file has the following fields (source:http://www.biostars.org/p/1495/):
    # chromosome name
    # chromosome length
    # offset of the first base of the chromosome sequence in the file
    # length of the fasta lines
    # some other length of the fasta lines called "line_blen" in the source code? Appears to typically (for me) be length of fasta line + 1.
    File.open(index_file).each do |line|
      line.chomp!
      fields = line.split("\t")
      scaffold_name = fields[0]
      scaffold_length = fields[1].to_i
      scaffold_offset = fields[2].to_i
      @index[scaffold_name] = [scaffold_length,scaffold_offset]
    end
  end

  def sequence(scaffold_name)
    scaffold_length = @index[scaffold_name][0]
    scaffold_offset = @index[scaffold_name][1]
    @filehandle.pos = scaffold_offset
    sequence = ""
    @filehandle.each do |line|
      line.chomp!
      break if line[0] == ">"
      #puts line
      sequence += line
    end
    puts sequence.length == scaffold_length
    sequence
  end

  def part_sequences(list_of_positions)
    positions = []
    scaf = {}
    list_of_positions.each do |pos|
      current_scaf = pos.split(":")[0]
      start = pos.split(":")[1].split("-")[0].to_i - 10**4
      stop = pos.split(":")[1].split("-")[1].to_i + 10**4
      act_start = pos.split(":")[1].split("-")[0].to_i
      act_stop = pos.split(":")[1].split("-")[1].to_i
      start = 0 if start < 0
      if scaf.has_value?(current_scaf)
        temp = false
        scaf.each_pair do |key,value|
          if value == current_scaf
            saved_start = key[0]
            saved_stop = key[1]
            if (saved_start-10**4 < act_start && saved_stop+10**4 > act_stop)
              temp = true
              puts "more fdgfd gfadgfadg yess"
              break
            end
          end
        end
        unless temp == true
          positions << "#{current_scaf}:#{start}-#{stop}"
          scaf[[start,stop]] = current_scaf
          puts "more yesy"
        end
      else
        scaf[[start,stop]] = current_scaf
        positions << "#{current_scaf}:#{start}-#{stop}"
      end
    end
    `samtools faidx hamster_unplaced.scaf.fa "#{positions.join("\" \"")}" > sequences.fa`
    positions
  end

end
