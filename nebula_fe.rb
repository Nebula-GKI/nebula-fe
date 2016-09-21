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
rescue Nebula::Identity::RootPathDoesNotExist
  if opts[:new] && !opts[:identity].blank?
    FileUtils.mkdir_p opts[:identity]
  else
    STDERR.puts "Identity does not exist at path: #{opts[:identity]}"
    STDERR.puts "Try running with the '--new' option"
    exit 1
  end
end

require 'sinatra'
require 'sinatra/json'

require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'
require 'multi_json'

# add our lib dir to the load path
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'error'
require 'utility'

raise 'No conversation directory specified.' if ARGV.length < 1

$conversation = Nebula::Conversation.new(ARGV.last)

get '/' do
  haml :main
end

# load controllers
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib/controllers")
Dir.glob("#{File.dirname(__FILE__)}/lib/controllers/*.rb").each do |lib|
    require_relative lib
end
