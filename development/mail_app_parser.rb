#!/usr/bin/env ruby

require 'pathname'
require 'message_history'
require 'message_history/apple_mail'
require 'message_history/persistence/in_memory'

mbox_path   = Pathname('/Users/stefan/Library/Mail/V2/IMAP-stefan.rusterholz@imap.gmail.com/INBOX.mbox')
MessageHistory.persistence = MessageHistory::Persistence::InMemory.new

def print_progress(n, of_m)
  printf(" %5.1f%% (%d/%d)                    \r", 100*n.fdiv(of_m), n, of_m)
end

$stdout.sync = true
begin
  print "\e[?25l"
  paths = Dir[mbox_path.join('**/*.emlx').to_s]
  total = paths.size
  paths.each_with_index do |path, idx|
    MessageHistory << MessageHistory::AppleMail.read(path)
    print_progress(idx, total)
  end
ensure
  print "\e[?25h"
  print " "*60
  print "\r"
  $stdout.sync = false
end

puts MessageHistory.size
