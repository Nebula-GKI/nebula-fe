module Nebula
  class Message
    include Utility
    class Error < Nebula::Error; end
    class MessageFileExists < Error; end

    attr_reader :conversation, :text

    def initialize(conversation, text)
      @conversation = conversation
      @text = text
    end

    def messages_path
      conversation.root_path + MAIN_DIR_NAME + 'messages'
    end

    def save
      message_file_path = messages_path + chrono_file_name('txt', conversation.user_name)
      messages_path.mkpath

      # we're not going to overwrite existing files
      # this should never happen since the filename includes a timestamp
      raise MessageFileExists, message_file_path.expand_path.to_s if message_file_path.exist?

      message_file_path.open('w') do |file|
        file.puts text
      end

      # :TODO: need to commit to git here

      text # just here to provide something to look at
    end
  end
end
