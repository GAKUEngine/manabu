require 'rspec'
require 'manabu'
# require 'gaku'
require 'faraday'

RSpec.configure do |config|
  config.before(:suite) do
    system('cd ../gaku; bin/gaku container start')
    loop do
      res = Faraday.get('http://localhost:9000/api/status') rescue nil
      break if res && res.status == 200
      puts 'Waiting'
      sleep 5
    end

  end

  config.after(:suite) do
    system('cd ../gaku; bin/gaku container delete')
  end
end
