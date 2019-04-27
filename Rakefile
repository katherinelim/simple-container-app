require 'rspec/core'
require 'rspec/core/rake_task'
require 'rack/test'

task default: :spec

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

RSpec::Core::RakeTask.new do |task|
  task.pattern = FileList['spec/**/*_spec.rb']
end
