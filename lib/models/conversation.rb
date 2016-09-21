require_relative '../error'
require 'pathname'

module Nebula
  MAIN_DIR_NAME = '.nebula'
  PATHS_TO_EXCLUDE = ['.', '..', '.DS_Store'].map {|p| Pathname.new(p)}

  class Conversation
    class Error < Nebula::Error; end
    class BlankRootPath < Error; end
    class RootPathDoesNotExist < Error; end

    attr_reader :root_path

    def initialize(root_path)
      raise BlankRootPath if root_path.to_s.blank?
      @root_path = Pathname.new(root_path).expand_path
      raise RootPathDoesNotExist, @root_path unless @root_path.exist?
    end

    def self.list(path)
      # :TODO: might be able to do this more idiomatically with collect
      conversations = Array.new
      if path.exist?
        path.children(true) do |c_path|
          conversations.push Conversation.new(c_path)
        end
      end
      conversations
    end
  end
end
