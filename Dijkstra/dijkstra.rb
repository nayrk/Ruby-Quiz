#!/usr/bin/env ruby

# Edges of a graph
class Edge
	attr_accessor :from, :to, :weight

	def initialize(from,to,weight)
		@from = from
		@to = to
		@weight = weight
	end
end

# Graph
class Graph
	def initialize(filename)
		@prev = {}
		@map = {}
		@vertices = {}
		@infinity = 1 << 64

		parse(filename) do |from,to,weight| 
			# Create undirected graph
			(@map[from] ||= [] ) << Edge.new(from,to,weight); 
			(@map[to] ||= [] ) << Edge.new(to,from,weight); 

			# Create vertices all with infinity
			@vertices[from] = @infinity
			@vertices[to] = @infinity

			# Set all parents to nil
			@prev[from] = nil
			@prev[to] = nil
		end

	end

	# Helper function to parse graph file
	def parse(filename)
		File.open(filename,"r").each do |line|
			from,to,weight = line.split(" ")
			yield from,to,weight
		end
	end

	# Wikipedia Algorithm Step by Step
	# http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
	# Dijkstras(goal,start)
	# start - initial node, set to first value of the sorted vertex
	# goal - destination node, set to nil by default
	def dijkstras(start=@vertices.keys.sort[0],goal=nil)
		# Set of visited nodes
		visited = []

		# Step 1 
		# - Start node weighs 0
		# - Set all other to infinity its done in constructor already
		@vertices[start] = 0

		# Step 2 
		# - Set initial node as current
		# - Mark all nodes unvisited except start node
		unvisited = @vertices.keys - [start]
		current = start

		while(!unvisited.empty?)
			# Step 3
			# - Consider all neighbors of current node
			# - Calculate distance cost: current path weight + edge weight
			# - Update distance if this distance is less than recorded distance
			
			@map[current].each do |neighbor|
				next if visited.include?(neighbor.to)
				weight = @vertices[current] + neighbor.weight.to_i
				if weight < @vertices[neighbor.to]
					@vertices[neighbor.to] = weight
					@prev[neighbor.to] = current
				end
			end

			# Step 4
			# - Add current node to visited
			# - Remove current node from unvisited
			visited << current
			unvisited -= [current]

			# Find the smallest weighted node
			current = unvisited.collect { |node| [@vertices[node],node] }
			current.empty? ? current = @infinity : current = current.min[1]

			# Step 5
			# - If goal is in visited, stop
			# - If full traversal without a goal? 
			# 	Check for infinity weighted node
			if visited.include? goal		
				path(goal)
				return
			end
			break if current == @infinity
		end
		
		# Print all shortest paths
		puts "Initial Node: #{start}"
		visited.each do |x|
			path(x)
			puts
		end
	end

	def path(dest)
		if @prev[dest] != nil
			path(@prev[dest])
		end
		printf("-> %s ",dest)
	end
end

graph = Graph.new(ARGV[0])
graph.dijkstras("1","6")
