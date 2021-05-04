class Tile
  attr_reader :bomb, :revealed, :flagged

  def initialize(bomb)
    @bomb = bomb
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
    @bomb ? '@' : '_'
  end

  def self.bomb_count(tiles)
    tiles.count(&:bomb)
  end
end
