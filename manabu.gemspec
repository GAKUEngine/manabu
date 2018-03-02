Gem::Specification.new do |s|
  s.name          = 'manabu'
  s.version       = '0.0.3'
  s.licenses      = ['AGPL-3.0', 'GPL-3.0']
  s.summary       = 'API client for GAKU Engine'
  s.description   = 'Manabu is an API client module used to access the GAKU Engine API'
  s.post_install_message =  \
    "╔═════════════════════════╼\n" +
    "║Manabu API Client for ⚙学 GAKU Engine [学エンジン] \n" +
    "╟─────────────────────────╼\n" +
    "║©2015 (株)幻創社 [Phantom Creation Inc.]\n" +
    "║http://www.gakuengine.com\n" +
    "╟─────────────────────────╼\n" +
    "║Manabu is Open Sourced under the AGPLv3/GPLv3.\n" +
    "╚═════════════════════════╼\n" 
  s.authors       = ['Rei Kagetsuki']
  s.email         = 'info@gakuengine.com'
  s.homepage      = 'http://www.gakuengine.com'

  s.files         = Dir.glob('lib/**/*.rb') +
                    ['manabu.gemspec']
  s.require_paths = ['lib']

  s.add_dependency 'faraday', '~> 0.13', '~> 0.13.1'
  s.add_dependency 'faraday_middleware', '~> 0.12', '~> 0.12.2'
  s.add_dependency 'typhoeus', '~> 1.3', '~> 1.3.0'
  s.add_dependency 'msgpack', '~> 1.2', '~> 1.2.2'
  s.add_development_dependency 'gaku', '~> 0.3.0', '~> 0.3.0.pre.4'
end
