class Tile
  attr_reader :bomb, :revealed, :flagged
  attr_accessor :neighbors

  def initialize(bomb)
    @bomb = bomb
    @neighbors = nil
    @revealed = false
    @flagged = false
  end

  def reveal
    @revealed = true unless @flagged
  end

  def toggle_flag
    if @flagged
      @flagged = false
    else
      @flagged = true unless @revealed
    end
  end

  def to_s
    return 'F' if @flagged
    return '*' unless @revealed
    return '@' if @bomb
    neighbor_bomb_count = self.neighbor_bomb_count
    neighbor_bomb_count > 0 ? neighbor_bomb_count.to_s : '_'
  end

  def neighbor_bomb_count
    @neighbors.count(&:bomb)
  end

  def revealable_neighbors
    neighbors
      .reject(&:flagged)
      .reject(&:revealed)
  end
end
