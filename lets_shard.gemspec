require_relative 'lib/lets_shard/version'

Gem::Specification.new do |spec|
  spec.name = 'lets_shard'
  spec.version = LetsShard::VERSION
  spec.authors = ['oshboul']
  spec.email = ['omar.abdula@gmail.com']

  spec.summary = spec.description = 'An easy way to shard anything!'
  spec.homepage = 'https://github.com/oshboul/lets_shard'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
