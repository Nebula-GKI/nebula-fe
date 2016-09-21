module Nebula
  class Identity
    class Error < Nebula::Error; end
    class RootPathDoesNotExist < Error; end

    def initialize(root_path)
      @root_path = Pathname.new(root_path).expand_path
      raise RootPathDoesNotExist, @root_path unless @root_path.exist?
    end
  end
end
