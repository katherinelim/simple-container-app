# server.rb
require 'logger'
require 'sinatra'
set :logger, Logger.new(STDOUT)
require 'sinatra/config_file'
config_file '../appmeta.yml'
config_file '../SHA_HEAD.yml'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?
require 'json'

get '/healthcheck' do
  logger.info('Example log - get healthcheck')
  content_type :json
  {
    myapplication: [
      version: settings.version,
      description: settings.description,
      lastcommitsha: settings.last_commit_sha
    ]
  }.to_json
end
