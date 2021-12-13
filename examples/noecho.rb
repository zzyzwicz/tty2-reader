# frozen_string_literal: true

require_relative "../lib/tty2-reader"

reader = TTY2::Reader.new

answer = reader.read_line("=> ", echo: false)
puts "Answer: #{answer}"
