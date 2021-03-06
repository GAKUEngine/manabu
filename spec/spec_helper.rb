require 'rspec'
require 'manabu'
require 'faraday'
require 'gaku/container'

RSpec.configure do |config|
  config.before(:suite) do
    if check_test_container() # if running a test container externally, leave it
      puts '🆗 Detected running container, not intializing a new container.'
      $external_test_container = true
    else
      puts '⚠ Demo server container not detected. Starting up....'
      $external_test_container = false
      Gaku::Container.Delete
      Gaku::Container.Start
      loop do
        break if check_test_container()
        puts '⏱ Waiting for server instance...'
        sleep 5
      end
    end
    Gaku::Container.Testing
  end

  config.after(:suite) do
    Gaku::Container.Delete unless $external_test_container
  end

  def check_test_container()
    res = Faraday.get('http://localhost:9000/api/v1/status')
    if res && res.status == 200
      puts '🆗 Received response from test container.'
      return true 
    end
  rescue
    false
  end

  config.filter_run_excluding timeouts: true
end
