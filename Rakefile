require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :build do
  system "rm hamster*.gem"
  system "gem build hamster.gemspec"
  system "gem install hamster*.gem"
end

task :release => :build do
  system "gem push hamster*.gem"
end
