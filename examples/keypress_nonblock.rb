# frozen_string_literal: true

require_relative "../lib/tty2-reader"

reader = TTY2::Reader.new

puts "Press a key (or Ctrl-X to exit)"

loop do
  print reader.cursor.clear_line
  print "=> "
  char = reader.read_keypress(nonblock: true)
  if char == ?\C-x
    puts "Exiting..."
    exit
  elsif char
    puts "#{char.inspect} [#{char.ord}] (hex: #{char.ord.to_s(16)})"
  end
end
