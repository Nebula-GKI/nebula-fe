require 'rubygems'
require 'bundler/setup'

require 'sinatra' unless defined?(Sinatra)
APP_ROOT = File.dirname(__FILE__)

configure do
    # load models
    $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib/models")
    Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb") do |lib|
      require File.basename(lib, '.*')
    end
end
