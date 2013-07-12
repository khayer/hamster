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

end
