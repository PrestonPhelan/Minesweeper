#require 'byebug'
class Minesweeper
  attr_reader :grid, :rows, :cols, :bombs
  attr_accessor :game_over

  def initialize
    @game_over = false
    @rows = 9
    @cols = 9
    @grid = Array.new(@rows) { Array.new(@cols) }
    @display_grid = Array.new(@rows) { Array.new(@cols, "-")}
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
    puts "Game over."
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
        puts "Choose a square to flag. e.g. 0,1"
        position = get_position
        if @display_grid[position[0]][position[1]] == "-"
          flag(position)
        else
          valid_input = false
          puts "Can't flag that square.  It has already been revealed."
        end
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

      if on_board?(pos)
        valid_input = true
      else
        puts "Not a valid input"
      end
    end

    pos
  end

  def reveal(pos)
    ##Reveals square indicated by pos
    ##If contains bomb
    if self[pos] == :B
      change_display(pos, :B)
      @game_over = true
      render
      puts "BOOM! You uncovered a bomb and it exploded!"
      puts "You lose."
    ##If it doesn't contain bomb
    else
      adjacents = adjacent_squares(pos)
      adjacent_bombs = 0
      adjacents.each do |square|
        adjacent_bombs += 1 if self[square] == :B
      end
      ##If adjacent bomb, display fringe
      change_display(pos, adjacent_bombs)
      ##Else reveal adjacent squares
      if adjacent_bombs == 0
        adjacents.each do |square|
          row, col = square[0], square[1]
          reveal(square) if @display_grid[row][col] == "-"
        end
      end
    end
  end

  def flag(pos)
    ##Flags square indicated by pos
  end

  def change_display(pos, value)
    row, col = pos[0], pos[1]
    @display_grid[row][col] = value
  end

  def render
    ##Renders display grid to console.
    print "  "
    cols.times { |i| print "#{i} " }
    puts ""
    @display_grid.each_with_index do |row, idx|
      print "#{idx} "
      row.each do |tile|
        print "#{tile} "
      end
      puts ""
    end
  end

  def adjacent_squares(pos)
    ##Returns list of adjacent squares
    row, col = pos[0], pos[1]
    up_row, down_row = pos[0] - 1, pos[0] + 1
    left_col, right_col = pos[1] - 1, pos[1] + 1

    adjacent_squares = [
      [up_row, left_col], [up_row, col], [up_row, right_col],
      [row, left_col], [row, col], [row, right_col],
      [down_row, left_col], [down_row, col], [down_row, right_col],
    ]

    adjacent_squares.select { |tile| on_board?(tile) }
  end

  def on_board?(pos)
    pos[0] < rows && pos[1] < cols && pos.all? { |el| el >= 0 }
  end
end

# test = Minesweeper.new
# test[[0, 1]] = :B
# p test.grid
#
# p Minesweeper.new.grid
Minesweeper.new.run
