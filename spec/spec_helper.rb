require 'rspec'
require 'manabu'
require 'faraday'
require 'gaku/container'

RSpec.configure do |config|
  config.before(:suite) do
    Gaku::Container.Start
    loop do
      res = Faraday.get('http://localhost:9000/api/status') rescue nil
      break if res && res.status == 200
      puts 'Waiting'
      sleep 5
    end

  end

  config.after(:suite) do
    Gaku::Container.Delete
  end
end
