require 'rubygems'
require 'bundler/setup'

# command line options parsing
# :NOTE: this MUST come before the "require 'sinatra'" or it's OptionParser will override trollop
require 'trollop'

opts = Trollop::options do
  version "Nebula-FE 0.1"
  banner <<-EOS
Nebula-FE acts as a frontend proof of concept for the Nebula protocol.

Usage:
       nebula-fe [options] <conversation_path>+
where [options] are:
EOS

  opt :identity, "Path to identity", type: :string, default: '~/.nebula/identity'
  opt :new, "Create a new conversation if one does not exist at the specified path"
end

require File.join(File.dirname(__FILE__), 'environment')

begin
  $identity = Nebula::Identity.new(opts[:identity])
rescue Nebula::Identity::BlankRootPath
  STDERR.puts 'The identity path cannot be blank'
  exit 2
rescue Nebula::Identity::RootPathDoesNotExist
  if opts[:new]
    identity_path = Pathname.new(opts[:identity])
    # we expand the path before calling mkdir_p so we don't end up creating literal tilde directories
    # turns out, Pathname.mkpath takes things very literally
    FileUtils.mkdir_p identity_path.expand_path
  else
    STDERR.puts "Identity does not exist at path: #{opts[:identity]}"
    STDERR.puts "Try running with the '--new' option"
    exit 1
  end
end

require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'

require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'
require 'multi_json'

class NebulaFe < Sinatra::Base
  helpers Sinatra::FormHelpers

  get '/' do
    @name = $identity.name
    haml :main
  end

  # load controllers
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib/controllers")
  Dir.glob("#{File.dirname(__FILE__)}/lib/controllers/*.rb").each do |lib|
      require_relative lib
  end

  run! if app_file == $0
end
