module Nebula
  class Message
    include Utility
    class Error < Nebula::Error; end

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
      message_file_path.expand_path.to_s
    end
  end
end
