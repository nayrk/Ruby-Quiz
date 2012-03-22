#!/usr/bin/env ruby

#Node class to represent the objects in the map
class Node
	attr_accessor :g_score, :f_score, :point, :terrain, :parent

	def initialize(terrain,point)
		@terrain = terrain	
		@f_score = 0
		@g_score = 0
		@point = point
		@parent = nil
	end

	def valid?
		self.terrain == "~" ? false : true
	end

	def cost
		case self.terrain
			when "."
				return 1
			when "*"
				return 2
			when "^"
				return 3
			else
				return 0
		end
	end
end

#Point for location of the node
class Point
	attr_accessor :x, :y

	def initialize(x,y)
		@x = x	
		@y = y
	end

	def == other
		return (@x == other.x and @y == other.y)
	end
end

# Inject with index
class Array
	def inject_with_index(injected)
		each_with_index{ |obj, index| injected = yield(injected, obj, index) }
		injected
	end
end

#A parsed map of nodes representing 
#our grid
class Map
	attr_accessor :map, :goal, :start

	def initialize(file)
		@map = []
		File.open(file).each_with_index do |line,row|
			@map << line.chomp.split(//).inject_with_index([]) do |arr,terrain,index|
				@goal = Node.new(terrain,Point.new(row,index)) if terrain == "X"
				@start = Node.new(terrain,Point.new(row,index)) if terrain == "@"
				arr << Node.new(terrain,Point.new(row,index))
			end
		end
		@map
	end

	def at(point)
		@map[point.x][point.y]
	end

	def neighbors(node)
		neighbors = []
		dx = node.point.x
		dy = node.point.y

		xbound = @map.size - 1
		ybound = @map[xbound].size - 1

		(-1..1).each do |p1|
			(-1..1).each do |p2|
				next if ((p1 + dx) > xbound)
				next if ((p2 + dy) > xbound)
				if !(at(Point.new(p1 + dx,p2 + dy))).nil?
					next if (p1 < 0 or p2 < 0 or (Point.new(p1,p2) == node.point))
					neighbors << at(Point.new(p1 + dx,p2 + dy))
				end
			end
		end
		neighbors
	end

	def heuristic(node)
		#return 0
		x1 = node.point.x
		y1 = node.point.y
		x2 = @goal.point.x
		y2 = @goal.point.y
		return ((x1 - x2).abs + (y1 - y2).abs)
	end

	def set(point)
		@map[point.x][point.y].terrain = "#"
	end

	def path
		@map.each do |row|
			string = ""
			row.each do |col|
				string += col.terrain
			end
			puts string
		end
	end
end

class PQ
	attr_accessor :list

	def initialize
		@list = []
	end

	def << node
		@list << node
		@list = @list.sort_by { |a| a.f_score }
	end

	def top
		@list.shift
	end

	def empty?
		return @list.size == 0
	end

	def include? node
		@list.each do |n|
			return true if n.point == node.point
		end
		return false
	end

	def get node
		@list.each do |n|
			if n.point == node.point
				node = n
				@list.delete n
			end
		end
		node
	end
end

# A* class, initializes with a given map and start on a node
class AStar
	attr_accessor :map

	def initialize(map)
		@map = map
	end

	def path(start=nil)
		return false if start == nil

		closed_list = PQ.new
		open_list = PQ.new
		open_list << start

		while !open_list.empty?
			# Get lowest F score in list and put it in closed list
			closed_list << (parent = open_list.top)

			if parent.terrain == "X"
				while(parent.parent != nil)
					@map.set(parent.point)
					parent = parent.parent
				end
				@map.set(parent.point)
				@map.path
				exit
			end

			@map.neighbors(parent).each do |node|
				next if !node.valid?
				next if closed_list.include? node
				if open_list.include? node
					if node.g_score > (node.cost + parent.g_score)
						node = open_list.get(node)
						node.parent = parent
						node.g_score = parent.g_score + node.cost
						node.f_score = node.g_score + @map.heuristic(node)
						open_list << node
					end
				else
					node.parent = parent
					node.g_score = parent.g_score + node.cost
					node.f_score = node.g_score + @map.heuristic(node)
					open_list << node
				end
			end
		end
	end
end

exit if ARGV[0].nil?
grid = Map.new(ARGV[0])
astar = AStar.new(grid)
astar.path(grid.start)
