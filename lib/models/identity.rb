require 'yaml'

module Nebula
  class Identity
    class Error < Nebula::Error; end
    class BlankRootPath < Error; end
    class RootPathDoesNotExist < Error; end

    attr_reader :root_path

    def initialize(root_path)
      raise BlankRootPath if root_path.to_s.blank?
      @root_path = Pathname.new(root_path).expand_path
      raise RootPathDoesNotExist, @root_path unless @root_path.exist?
    end

    def name=(name)
      (root_path + 'identity.yaml').open('w') do |f|
        f.write YAML.dump({name: name})
      end
    end
  end
end
