require 'movement'

class NoLegalMoves < Exception; end
class UnsolvableError < Exception; end

class Board
  attr_reader :balls, :movements

  def initialize
    @movements = []
    @balls = 0
    @columns = (0..10).map {|p| (0..10).map {|q| :empty}}
    @rows = (0..10).map {|p| (0..10).map {|q| :empty}}
  end

  def add_ball(x, y)
    @balls += 1
    @columns[x][y] = :ball
    @rows[y][x] = :ball
  end

  def remove_ball(x, y)
    @balls -= 1
    @columns[x][y] = :empty
    @rows[y][x] = :empty
  end

  def solve
    if @balls == 1
      return @movements 
    else
      lmoves = legal_moves
      raise NoLegalMoves if lmoves.empty?
      legal_moves.each do |lmove|
        board = self.dup
        board.move(lmove, true)
        begin
          return board.solve
        rescue NoLegalMoves

        rescue UnsolvableError

        end
      end
      raise UnsolvableError
    end
  end

  def move(movement, record = true)
    @movements << movement if record
    send("move_#{movement.direction}", movement.x, movement.y)
  end

  def move_down(x, y)
    if y == 0
      remove_ball(x, y)
    else
      space = @columns[x][y]
      down_space = @columns[x][y-1]
      @rows[y][x] = @columns[x][y] = down_space
      @rows[y-1][x] = @columns[x][y-1] = space
      move_down(x, y-1)
    end
  end

  def move_up(x, y)
    if y == @columns[x].size - 1
      remove_ball(x, y)
    else
      space = @columns[x][y]
      up_space = @columns[x][y+1]
      @rows[y][x] = @columns[x][y] = up_space
      @rows[y+1][x] = @columns[x][y+1] = space
      move_up(x, y+1)
    end
  end

  def move_right(x, y)
    if x == @rows[y].size - 1
      remove_ball(x, y)
    else
      space = @columns[x][y]
      left_space = @columns[x+1][y]
      @rows[y][x] = @columns[x][y] = left_space
      @rows[y][x+1] = @columns[x+1][y] = space
      move_right(x+1, y)
    end
  end

  def move_left(x, y)
    if x == 0
      remove_ball(x, y)
    else
      space = @columns[x][y]
      left_space = @columns[x-1][y]
      @rows[y][x] = @columns[x][y] = left_space
      @rows[y][x-1] = @columns[x-1][y] = space
      move_left(x-1, y)
    end    
  end

  def solved?
    @balls == 1
  end

  def legal_moves
    moves = []
    @columns.each_with_index do |column, x|
      column.each_with_index do |space, y|
        if space == :ball
          # If there's a ball above me and not next to me, I can move up
          moves << Movement.new(x, y, :up) if y < 7 && column[y+1, 8].include?(:ball) && column[y+1] != :ball
          # If there's a ball below me and not next to me, I can move down
          moves << Movement.new(x, y, :down) if y > 0 && column[0, y-1].include?(:ball) && column[y-1] != :ball
        end
      end
    end
    @rows.each_with_index do |row, y|
      row.each_with_index do |space, x|
        if space == :ball
          # If there's a ball above me and not next to me, I can move up
          moves << Movement.new(x, y, :right) if x < 6 && row[x+1, 8].include?(:ball) && row[x+1] != :ball
          # If there's a ball below me and not next to me, I can move down
          moves << Movement.new(x, y, :left) if x > 0 && row[0, x-1].include?(:ball) && row[x-1] != :ball
        end
      end
    end
    moves
  end
end