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
    set_tile_neighbors
  end

  def set_tile_neighbors
    (0...SIZE).each do |row|
      (0...SIZE).each do |col|
        pos = [row, col]
        self[pos].neighbors = neighbors(pos)
      end
    end
  end

  def reveal(pos)
    tile = self[pos]
    return if tile.revealed

    tile_queue = [tile]
    until tile_queue.empty?
      current_tile = tile_queue.shift
      next if current_tile.flagged

      current_tile.reveal
      unless current_tile.bomb || current_tile.neighbor_bomb_count > 0
        tile_queue += current_tile.revealable_neighbors
      end
    end
  end

  def toggle_flag(pos)
    self[pos].toggle_flag
  end

  def bomb_revealed?
    @board.flatten.any? { |tile| tile.bomb && tile.revealed }
  end

  def cleared?
    remaining_tiles = @board.flatten.reject(&:revealed)
    remaining_tiles.length == BOMBS && remaining_tiles.all?(&:bomb)
  end

  def game_over?
    cleared? || bomb_revealed?
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
