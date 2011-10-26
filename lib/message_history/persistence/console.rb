# encoding: utf-8

module MessageHistory
  module Persistence
    class Console
      include Enumerable

      def initialize
        @messages = 0
      end

      def <<(message)
        @messages += 1
        puts "we now have #{@messages} messages"
        puts message
      end

    end
  end
end
