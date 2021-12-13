# frozen_string_literal: true

require_relative "completions"

module TTY2
  class Reader
    # Responsible for word completion
    #
    # @api private
    class Completer
      # The completion suggestions
      attr_reader :completions

      # The handler for finding word completion suggestions
      attr_accessor :handler

      # The suffix to add to suggested word completion
      attr_accessor :suffix

      # Enable / Disable Cycling
     attr_accessor :cycling

      # The word to complete
      attr_reader :word

      # Create a Completer instance
      #
      # @api private
      def initialize(handler: nil, suffix: "", cycling: true)
        @handler = handler
        @suffix = suffix
        @cycling = cycling
        @completions = Completions.new
        @show_initial = false
        @word = ""
      end

      # Find a suggestion to complete a word
      #
      # @param [Line] line
      #   the line to complete a word in
      # @param [Symbol] direction
      #   the direction in which to cycle through completions
      # @param [Boolean] initial
      #   whether to find initial or next completion suggestion
      #
      # @return [String, nil]
      #   the completed word or nil when no suggestion is found
      #
      # @api public
      def complete(line, direction: :next, initial: false)
        if initial
          complete_initial(line, direction: direction)
        elsif @cycling
          complete_next(line, direction: direction)
        end
      end

      # Complete the initial word
      #
      # @param [Line] line
      #   the line to complete a word in
      # @param [Symbol] direction
      #   the direction in which to cycle through completions
      #
      # @return [String, nil]
      #   the completed word or nil when no suggestion is found
      #
      # @api public
      def complete_initial(line, direction: :next)
        completed_word = complete_word(line)
        return if @completions.empty?
        if @cycling && completions.size > 1
          @word = line.word_to_complete
          position = word.length
          completions.previous if direction == :previous
          completed_word = completions.get
          line.insert(completed_word[position..-1])
        end
        completed_word
      end

      # Complete a word with the next suggestion from completions
      #
      # @param [Line] line
      #   the line to complete a word in
      # @param [Symbol] direction
      #   the direction in which to cycle through completions
      #
      # @return [String, nil]
      #   the completed word or nil when no suggestion is found
      #
      # @api public
      def complete_next(line, direction: :next)
        return if completions.size < 2

        previous_suggestion = completions.get
        first_or_last = direction == :previous ? :first? : :last?
        if completions.send(first_or_last) && !@show_initial
          @show_initial = true
          completed_word = word
        else
          if @show_initial
            @show_initial = false
            previous_suggestion = word
          end
          completions.send(direction)
          completed_word = completions.get
        end

        length_to_remove = previous_suggestion.length

        line.remove(length_to_remove)
        #Due to a suspected timeing issue, verify all chars have actually been removed
        if line.word_to_complete.length == 0
          line.insert(completed_word)
          completed_word
        else
          completions.previous
          return
        end

      end

      # Get suggestions and populate completions
      #
      # @param [Line] line
      #   the line to complete a word in
      #
      # @api public
      def load_completions(line)
        @word = line.word_to_complete
        context = line.subtext[0..-@word.length]
        suggestions = handler.(word, context)
        suggestions = suggestions.grep(/^#{Regexp.escape(@word)}/)
        completions.clear
        return if suggestions.empty?
        completions.concat(suggestions)
      end

      # Find suggestions and complete the current word as far as it is unambigous
      #
      # @param [Line] line
      #   the line to complete a word in
      #
      # @return [String]
      #   the completed word
      #
      # @api public
      def complete_word(line)
        load_completions(line)

        return if completions.empty?

        position = @word.length
        if completions.size > 1
          char = completions.first[position]
          while completions.all? { |candidate| candidate[position] == char }
            line.insert(char)
            @word = line.word_to_complete
            position = @word.length
            char = completions.first[position]
          end
          completed_word = word
        elsif completions.size == 1
          completed_word = completions.first
          line.insert(completions.first[position..-1] + suffix)
        end

        completed_word
      end

      # Cancel completion suggestion and revert to the initial word
      #
      # @param [Line] line
      #   the line to cancel word completion in
      #
      # @api public
      def cancel(line)
        return if completions.empty?

        completed_word = @show_initial ? word : completions.get
        line.remove(completed_word.length)
        line.insert(word)
      end
    end # Completer
  end # Reader
end # TTY2
