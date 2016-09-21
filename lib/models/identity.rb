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
      # :TODO: we should probably be logging a warning here
      return Hash.new('MISSING') unless identity_file.exist?

      identity_file_mtime = identity_file.mtime
      if (@identity_store.nil? or identity_file_mtime != @identity_file_mtime)
        @identity_file_mtime = identity_file_mtime
        @identity_store = YAML.load_file(identity_file)
      end

      # this is to handle an empty file
      # :TODO: we should probably be logging a warning here
      @identity_store || Hash.new('EMPTY')
    end

    def name
      identity_store[:name]
    end

    def name=(name)
      identity_file.open('w') do |f|
        f.write YAML.dump({name: name})
      end
    end

    def conversations_path
      # identity_store[:conversations_path] || Pathname.new('~/conversations').expand_path
      Pathname.new('~/conversations').expand_path
    end
  end
end
