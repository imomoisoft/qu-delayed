require 'qu-delayed'

module Qu
  class Railtie < Rails::Railtie
    rake_tasks do
      load "qu/delayed/tasks.rb"
    end
  end
end
