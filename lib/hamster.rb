class Hamster

  def initialize()
  end

end

require 'logger'
require 'hamster/logging'
include Logging
require 'hamster/functions'
include Functions
require 'hamster/vcf'
require 'hamster/fasta'
