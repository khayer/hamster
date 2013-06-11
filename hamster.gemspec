Gem::Specification.new do |s|
  s.name        = 'hamster'
  s.version     = '0.0.1'
  s.date        = '2013-05-28'
  s.summary     = "Hamster Scripts"
  s.description = "..."
  s.authors     = ["Katharina Hayer"]
  s.email       = 'katharinaehayer@gmail.com'
  s.files       = Dir.glob("lib/**/*")
  s.homepage    =
    'https://github.com/khayer/hamster'
  s.executables = Dir.glob("bin/**/*").map{|f| File.basename(f)}
end
