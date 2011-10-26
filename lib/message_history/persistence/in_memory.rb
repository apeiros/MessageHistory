# encoding: utf-8



module MessageHistory
  module Persistence
    class InMemory
      include Enumerable

      def initialize
        @messages = []
      end

      def <<(message)
        @messages << message.to_message
      end

      def each(&block)
        @messages.each(&block)
      end

      def size
        @messages.size
      end
    end
  end
end
