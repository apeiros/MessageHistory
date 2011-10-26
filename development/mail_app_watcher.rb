#!/usr/bin/env ruby

require 'message_history'
require 'message_history/apple_mail'
require 'message_history/persistence/console'

MessageHistory.persistence = MessageHistory::Persistence::Console.new

$stdout.sync = true

MessageHistory::AppleMail.watch
