require 'gaku/container'

namespace :testing do
  namespace :container do
    desc 'Starts the testing container'
    task :up do
      Gaku::Container.Start
    end

    desc 'Stops the testing container'
    task :down do
      Gaku::Container.Delete
    end
  end
end
