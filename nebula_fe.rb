require 'pathname'
require 'sinatra'

raise 'No conversation directory specified.' if ARGV.length < 1

conversation_root_dir = Pathname.new(ARGV.first)

get '/' do
  conversation_root_dir.entries.join("<br>\n")
end
