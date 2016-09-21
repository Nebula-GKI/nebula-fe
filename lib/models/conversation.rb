require_relative '../error'
require 'pathname'

module Nebula
  MAIN_DIR_NAME = '.nebula'
  PATHS_TO_EXCLUDE = ['.', '..', '.DS_Store'].map {|p| Pathname.new(p)}

  class Conversation
    class Error < Nebula::Error; end
    class RootPathDoesNotExist < Error; end

    attr_reader :root_path, :user_name

    def initialize(root_path)
      @root_path = Pathname.new(root_path).expand_path
      raise RootPathDoesNotExist, @root_path unless @root_path.exist?

      # :TODO: read actual username from local node
      @user_name = 'USERNAME'
    end
  end
end
