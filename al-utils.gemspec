# encoding: utf-8
require File.expand_path('../lib/al/utils/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'al-utils'
  spec.version       = Al::Utils::VERSION
  spec.authors       = ['Pablo Salazar']
  spec.email         = ['pablo@aceleracion.cl']
  spec.summary       = %q{Gem for shared modules}
  spec.description   = %q{All shared code between engines must be here}
  spec.homepage      = 'https://bitbucket.org/aceleracionlabs/al-utils'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split('\n')
  spec.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  spec.require_paths = ['lib']
end
