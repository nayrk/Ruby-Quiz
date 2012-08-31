# Game of Life by Conway
#
# Rules:
# Any live cell with fewer than two live neighbours dies, as if by needs caused by underpopulation.
# Any live cell with more than three live neighbours dies, as if by overcrowding.
# Any live cell with two or three live neighbours lives, unchanged, to the next generation.
# Any dead cell with exactly three live neighbours becomes a live cell.

class Cell
  attr_accessor :state

  def initialize(alive=false)
    @state = (alive ? "o" : ".")
  end

  # Check for neighbors
  def neighbors(grid,h,w)
    neighbors = 0

    neighbors += 1 if(grid[h-1][w-1].state == "o")
    neighbors += 1 if(grid[h-1][w].state == "o")
    neighbors += 1 if(grid[h-1][w+1].state == "o")
    neighbors += 1 if(grid[h][w-1].state == "o")
    neighbors += 1 if(grid[h][w+1].state == "o")
    neighbors += 1 if(grid[h+1][w-1].state == "o")
    neighbors += 1 if(grid[h+1][w].state =="o")
    neighbors += 1 if(grid[h+1][w+1].state == "o")

    neighbors
  end
end

class Grid
  def initialize(h=30,w=30)
    @h = h
    @w = w
    @grid = Array.new(h){ Array.new(w){Cell.new} }
  end

  def play
    init
    while 1
      display
      @grid = nextState
      puts
      sleep 1.5
    end
  end

  private
  def display
    @grid.each do |row|
      line = ""
      row.each do |cell|
        line += cell.state
      end
      puts line
    end
  end

  def init
    @grid[0][0].state = "o"
    @grid[0][1].state = "o"
    @grid[0][2].state = "o"
    @grid[5][3].state = "o"
    @grid[5][4].state = "o"
    @grid[5][5].state = "o"
  end

  def nextState
    nextGrid = Array.new(@h){ Array.new(@w){Cell.new} }

    0.upto(@h-2) do |h|
      0.upto(@w-2) do |w|
        if @grid[h][w].neighbors(@grid,h,w) < 2 and @grid[h][w].state == "o"
          nextGrid[h][w].state = "."
        elsif @grid[h][w].neighbors(@grid,h,w) > 3 and @grid[h][w].state == "o"
          nextGrid[h][w].state = "."
        elsif (@grid[h][w].neighbors(@grid,h,w) == 2 or @grid[h][w].neighbors(@grid,h,w) == 3) and @grid[h][w].state == "o"
          nextGrid[h][w].state = "o"
        elsif @grid[h][w].neighbors(@grid,h,w) == 3 and @grid[h][w].state == "."
          nextGrid[h][w].state = "o"
        end
      end
    end

    nextGrid
  end
end

if __FILE__ == $PROGRAM_NAME
  # Initialize the grid
  grid = Grid.new(10,10)

  # Play the game
  grid.play
end
