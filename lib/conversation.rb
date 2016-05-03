require 'pathname'

module Nebula
  class Conversation
    attr_reader :root_path

    def initialize(root_path)
      @root_path = Pathname.new(root_path)
    end
  end
end
