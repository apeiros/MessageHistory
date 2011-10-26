# encoding: utf-8

Gem::Specification.new do |s|
  s.name                      = "message_history"
  s.version                   = "0.0.1"
  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1")
  # According to Eric Hodel (Rubygems maintainer), you should generally not set this value
  # s.date                      = "2011-10-26"
  s.authors                   = "Stefan Rusterholz"
  s.description               = <<-DESCRIPTION.gsub(/^    /, '').chomp
    Search your message history.
  DESCRIPTION
  s.summary                   = <<-SUMMARY.gsub(/^    /, '').chomp
    Search your message history.
  SUMMARY
  s.email                     = "stefan.rusterholz@gmail.com"
  s.files                     =
    Dir['bin/**/*'] +
    Dir['lib/**/*'] +
    Dir['rake/**/*'] +
    Dir['test/**/*'] +
    %w[
      message_history.gemspec
      Rakefile
      README.markdown
    ]
  s.require_paths             = %w[lib]
  if File.directory?('bin') then
    executables = Dir.chdir('bin') { Dir.glob('**/*').select { |f| File.executable?(f) } }
    s.executables = executables unless executables.empty?
  end
  s.rubygems_version          = "1.3.1"
  s.specification_version     = 3

  s.add_dependency("plist")
  s.add_dependency("mail")
end
