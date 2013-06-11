require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :build do
  system "rm benchmarking_scripts*.gem"
  system "gem build benchmarking_scripts.gemspec"
  system "gem install benchmarking_scripts*.gem"
end

task :release => :build do
  system "gem push benchmarking_scripts*.gem"
end
