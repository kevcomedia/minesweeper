require_relative 'tile'

class Board
  SIZE = 9
  BOMBS = 10

  def initialize
    @board = nil
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
end
