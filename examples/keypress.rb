# frozen_string_literal: true

require_relative "../lib/tty2-reader"

reader = TTY2::Reader.new

puts "Press a key (or Ctrl-X to exit)"

loop do
  print "=> "
  char = reader.read_keypress
  if char == ?\C-x
    puts "Exiting..."
    exit
  else
    puts "#{char.inspect} [#{char.ord}] (hex: #{char.ord.to_s(16)})"
  end
end
