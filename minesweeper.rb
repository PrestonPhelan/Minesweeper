#require 'byebug'

class Minesweeper
  attr_reader :grid, :rows, :cols, :bombs
  attr_accessor :game_over

  def initialize
    @game_over = false
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

  def run
    until game_over
      ##Render board
      play_turn
    end

    ##Print end of game message
  end

  def play_turn
    valid_input = false
    until valid_input
      puts "Choose 'Reveal' or 'Flag'"
      input = gets.chomp
      case input
      when 'Reveal'
        valid_input = true
        puts "Choose a square to reveal. e.g. 0,1"
        position = get_position
        reveal(position)
      when 'Flag'
        valid_input = true
        puts "Chosse a square to flag. e.g. 0,1"
        position = get_position
        flag(position)
      else
        puts "That's not a valid choice."
      end
    end
  end

  def get_position
    ##Translates an input into a position array
    valid_input = false
    pos = nil
    until valid_input
      puts "Enter a valid input"
      print ">"
      input = gets.chomp

      pos = input.split(",").map(&:to_i)

      if pos[0] < rows && pos[1] < cols && pos.all? { |el| el >= 0 }
        valid_input = true
      else
        puts "Not a valid input"
      end
    end

    pos
  end

  def reveal(pos)
    ##Reveals square indicated by pos
  end

  def flag(pos)
    ##Flags square indicated by pos
  end
end

# test = Minesweeper.new
# test[[0, 1]] = :B
# p test.grid
#
# p Minesweeper.new.grid
Minesweeper.new.run
