require 'colorize'

class Tile
  attr_reader :bomb, :revealed, :flagged
  attr_accessor :neighbors

  BOMB_HINT_COLORS = {
    1 => :light_blue,
    2 => :green,
    3 => :light_red,
    4 => :blue,
    5 => :magenta,
    6 => :cyan,
    7 => :light_black,
    8 => :light_black,
  }

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
    return 'F'.red.on_white if @flagged
    return '*' unless @revealed
    return '@'.black.on_red if @bomb

    neighbor_bomb_count = self.neighbor_bomb_count
    return '_'.light_black if neighbor_bomb_count == 0

    color = BOMB_HINT_COLORS[neighbor_bomb_count]
    neighbor_bomb_count.to_s.colorize(color)
  end

  def neighbor_bomb_count
    @neighbors.count(&:bomb)
  end

  def revealable_neighbors
    neighbors
      .reject(&:flagged)
      .reject(&:revealed)
  end

  def inspect
    { bomb: @bomb, revealed: @revealed, flagged: @flagged }.inspect
  end
end
