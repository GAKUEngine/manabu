Gem::Specification.new do |s|
  s.name         = 'manabu'
  s.version      = '0.0.2'
  s.licenses     = ['AGPLv3', 'GPLv3']
  s.summary      = 'API client for GAKU Engine'
  s.description  = 'Manabu is an API client module used to access the GAKU Engine API'
  s.post_install_message =  \
    '╔═════════════════════════╼' +
    "║Manabu API Client for ⚙学 GAKU Engine [学エンジン] " +
    '╟─────────────────────────╼' +
    '║©2016 (株)幻創社 [Phantom Creation Inc.]' +
    '║http://www.gakuengine.com' +
    '╟─────────────────────────╼' +
    '║Manabu is Open Sourced under the AGPLv3/GPLv3.' +
    '╚═════════════════════════╼' 
  s.authors      = ['Rei Kagetsuki']
  s.email        = 'info@gakuengine.com'
  s.homepage     = 'http://www.gakuengine.com'

  s.files       = Dir.glob('lib/**/*.rb') +
                  ['manabu.gemspec']
  s.require_paths = ['lib']

  s.add_dependency 'faraday', '~> 0.13', '~> 0.13.1'
  s.add_dependency 'faraday_middleware', '~> 0.12', '~> 0.12.2'
  s.add_dependency 'typhoeus', '~> 1.3', '~> 1.3.0'
  s.add_dependency 'msgpack', '~> 1.1', '~> 1.1.0'
end
