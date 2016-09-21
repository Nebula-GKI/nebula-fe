module Nebula
  class Task
    class Error < Nebula::Error; end

    def self.root_path
      Pathname.new '.nebula/tasks'
    end

    attr_reader :summary, :description

    def initialize(summary, description = nil)
      @summary = summary
      @description = description
    end

    def save(conversation)
      path = conversation.root_path + Task.root_path #+ Nebula::chrono_file_name('.yml')
      puts "Saving task at: #{path}"
    end
  end
end
