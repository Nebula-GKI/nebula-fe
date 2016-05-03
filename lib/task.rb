module Nebula
  class Task
    class Error < Nebula::Error; end
    attr_reader :summary, :description

    def initialize(summary, description = nil)
      @summary = summary
      @description = description
    end
  end
end
