#!/usr/bin/env ruby

# Priority queue with Array as base
class PQueue
	def initialize
		@list = []
	end

	def << val
		@list << val
		@list = @list.sort_by { |arr| arr.size }
	end

	def first
		# Important to return duplicate copy, not reference
		@list.first.dup
	end

	def empty?
		@list.empty?
	end

	def pop
		@list.shift
	end

	def last
		@list.last
	end
end

class WordLadder
	def initialize(filename)
		@dictionary = File.open(filename).read.split("\n")
	end

	def ladder(start,goal)
		# PQueue to get smallest ladder first by length
		worklist = PQueue.new

		# Ladder
		stack = []

		# Push in start word into the stack
		stack << start

		# Push ladder into worklist
		worklist << stack

		# Continue while we got ladders to work and goal not yet reached
		while(!worklist.empty?)
			@dictionary.each do |word|
				if neighbors?(word, worklist.first.last)
					if(word == goal)
						stack = worklist.first
						stack << goal
						worklist << stack
						puts "Word Ladder:"
						worklist.last.each do |word|
							puts word
						end
						return
					end
					# Grab first stack from queue
					stack = worklist.first
					# Append the neighboring word
					stack << word
					# Push the possible ladder into the queue
					worklist << stack	
					# Delete the word from the dictionary
					@dictionary.delete(word)
				end
			end
			worklist.pop
		end
		puts "No word ladder found!"
	end

	# Test for 1 letter difference
	def neighbors?(start,word)
		return false if start.size != word.size
		count = 0
		length = start.size
		length.times do |index|
			if start[index..index] != word[index..index]
				count += 1
			end
		end
		return (count == 1)
	end
end

if __FILE__ == $PROGRAM_NAME
	if ARGV.size != 3
		$stderr.puts "./wordladder.rb <dict> <start> <end>"
		exit 1
	end
	wl = WordLadder.new(ARGV[0])
	wl.ladder(ARGV[1],ARGV[2])
end
