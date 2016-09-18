require 'pathname'

module Nebula
  MAIN_DIR_NAME = '.nebula'

  class Conversation
    attr_reader :root_path, :user_name

    def initialize(root_path)
      @root_path = Pathname.new(root_path)
      # :TODO: read actual username from local node
      @user_name = 'USERNAME'
    end
  end
end
