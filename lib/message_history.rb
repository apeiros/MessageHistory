# encoding: utf-8



require 'message_history/version'
require 'message_history/apple_mail'
require 'message_history/message'
require 'message_history/persistence/in_memory'



# MessageHistory
# Search your message history.
module MessageHistory
  class <<self
    attr_accessor :persistence
  end

  def self.<<(message)
    @persistence << message
  end

  def self.size
    @persistence.size
  end
end
