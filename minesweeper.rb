#require 'byebug'

class Minesweeper
  attr_reader :grid, :rows, :cols, :bombs

  def initialize
    @rows = 9
    @cols = 9
    @grid = Array.new(@rows) { Array.new(@cols) }
    @bombs = 10
    seed_bombs
  end

  def seed_bombs
    bombs.times do
      position = []
      loop do
        position = [rand(@rows), rand(@cols)]
        break if empty?(position)
      end

      self[position] = :B
    end
  end

  def [](pos)
    row, col = pos[0], pos[1]
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos[0], pos[1]
    @grid[row][col] = value
  end

  def empty?(pos)
    grid[pos[0]][pos[1]].nil?
  end
end

# test = Minesweeper.new
# test[[0, 1]] = :B
# p test.grid
#
# p Minesweeper.new.grid
