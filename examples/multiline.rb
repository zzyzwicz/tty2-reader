# frozen_string_literal: true

require_relative "../lib/tty2-reader"

reader = TTY2::Reader.new

puts "Press Ctrl-D or Ctrl-Z to finish"
answer = reader.read_multiline(">> ")
puts "\nanswer: #{answer}"
