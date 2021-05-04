class Tile
  attr_reader :bomb, :revealed

  def initialize(bomb)
    @bomb = bomb
    @revealed = false
  end

  def reveal
    @revealed = true
  end
end
