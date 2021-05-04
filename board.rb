require_relative 'tile'

class Board
  SIZE = 9
  BOMBS = 10

  def initialize
    @board = nil
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def seed
    bomb_locations = (0...SIZE**2).to_a.sample(BOMBS)
    tiles = (0...SIZE**2).map do |i|
      has_bomb = bomb_locations.include?(i)
      Tile.new(has_bomb)
    end
    @board = (0...SIZE).map { |i| tiles[i * SIZE...(i + 1) * SIZE] }
  end

  def render
    @board.each do |row|
      puts row.join
    end
    nil
  end

  def neighbors(pos)
    neighbor_pos(pos).map { |p| self[p] }
  end

  def neighbor_pos(pos)
    row, col = pos
    (row - 1..row + 1).flat_map do |r|
      (col - 1..col + 1).map { |c| [r, c] }
        .select { |p| Board::valid_pos?(p) }
        .reject { |p| p == pos }
    end
  end

  def self.valid_pos?(pos)
    pos.all? { |p| 0 <= p && p < SIZE }
  end
end
