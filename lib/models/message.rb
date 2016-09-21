require_relative '../utility'

module Nebula
  class Message
    include Utility
    extend Utility
    class Error < Nebula::Error; end
    class NilConversation < Error; end
    class MessageFileExists < Error; end
    class EntryIgnored < Error; end

    attr_reader :conversation, :text

    def initialize(conversation, text)
      raise NilConversation if conversation.nil?

      @conversation = conversation
      @text = text
    end

    def self.messages_path(conversation)
      conversation.root_path + MAIN_DIR_NAME + 'messages'
    end

    def messages_path
      Message.messages_path(conversation)
    end

    def save
      message_file_path = messages_path + chrono_file_name('txt', file_safe_user_name($identity.name))
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

    def self.list(conversation)
      raise NilConversation if conversation.nil?

      messages = Array.new
      msg_path = Message::messages_path(conversation)
      STDERR.puts "reading messages from: #{msg_path.expand_path}"
      msg_path.children(true).each do |message_path|
        begin
          raise EntryIgnored if PATHS_TO_EXCLUDE.include?(message_path)

          STDERR.puts message_path.expand_path
          # :TODO: replace this name extraction from the file with proper identity management
          message_info = parse_chrono_file_name(message_path.basename.to_s)
          messages.push({name: message_info[:name], message: message_path.read.chomp})
        rescue EntryIgnored
        rescue ArgumentError
          # ignore files with incorrect date strings
        end
      end
      messages
    end

    def self.file_safe_user_name(name)
      name.to_s.tr('^A-Za-z0-9 ', '').tr(' ', '_')
    end
  end
end
