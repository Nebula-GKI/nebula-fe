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

    def identity_file
      @identity_file ||= (root_path + 'identity.yaml')
    end

    def identity_store
      @identity_store ||= YAML.load_file(identity_file)
    end

    def name
      @name ||= identity_store.fetch(:name, '')
    end

    def name=(name)
      identity_file.open('w') do |f|
        f.write YAML.dump({name: name})
      end
    end
  end
end
