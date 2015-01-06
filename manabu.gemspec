Gem::Specification.new do |s|
  s.name         = 'manabu'
  s.summary      = 'Workstation client for GAKU Engine'
  s.description  = \
    ' Engine is a highly customizable Open Source School Management System. ' +
  s.post_install_message =  \
    '╔═════════════════════════╼' +
    "║Manabu for ⚙学 GAKU Engine [学エンジン] " +
    '╟─────────────────────────╼' +
    '║©2015 幻信創造株式会社 [Phantom Creation Inc.]' +
    '║http://www.gakuengine.com' +
    '╟─────────────────────────╼' +
    '║Manabu is Open Sourced under the GPL.' +
    '╚═════════════════════════╼' 
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec}/*`.split("\n")
end
