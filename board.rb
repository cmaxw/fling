require 'move'

class UnsolvableException < Exception
  
end

class Board
  attr_reader :balls

  def initialize
    @balls = 0
    @columns = (0..6).map {|p| (0..7).map {|q| :empty}}
    @rows = (0..7).map {|p| (0..6).map {|q| :empty}}
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

  def move_ball(move, record = true)
    #Check direction
    case move.direction
    when :up
      @columns[move.x].each {}
    when :down
      
    when :right
      
    when :left
      
    end
    #Find the ball it will collide with
    #Remove the ball being moved
    #Add the moved ball in the new position
    #Move the collided ball
  end
  
  def solve
    legals = legal_moves
    return @moves if solved?
    raise UnsolvableException if legals.empty?
    legals.each do |move|
      board = self.dup
      board.move_ball(move)
      solution = move_board.solve rescue UnsolvableException
    end
    return solution
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
          moves << Move.new(x, y, :up) if y < 7 && column[y+1, 8].include?(:ball) && column[y+1] != :ball
          # If there's a ball below me and not next to me, I can move down
          moves << Move.new(x, y, :down) if y > 0 && column[0, y-1].include?(:ball) && column[y-1] != :ball
        end
      end
    end
    @rows.each_with_index do |row, y|
      row.each_with_index do |space, x|
        if space == :ball
          # If there's a ball above me and not next to me, I can move up
          moves << Move.new(x, y, :right) if x < 6 && row[x+1, 8].include?(:ball) && row[x+1] != :ball
          # If there's a ball below me and not next to me, I can move down
          moves << Move.new(x, y, :left) if x > 0 && row[0, x-1].include?(:ball) && row[x-1] != :ball
        end
      end
    end
    moves
  end
end