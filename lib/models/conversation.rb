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

    def initialize(root_path, create = false)
      raise BlankRootPath if root_path.to_s.blank?
      @root_path = Pathname.new(root_path).expand_path
      begin
        raise RootPathDoesNotExist, @root_path unless @root_path.exist?
      rescue RootPathDoesNotExist
        if create
          @root_path.mkpath
        else
          raise
        end
      end
    end

    def name
      root_path.basename
    end

    def self.list(path)
      # :TODO: might be able to do this more idiomatically with collect
      if path.exist?
        path.children(true).collect do |c_path|
          Conversation.new(c_path)
        end
      else
        Array.new
      end
    end
  end
end
