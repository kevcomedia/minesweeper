require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  def play
    @board.seed
    until @board.game_over?
      begin
        @board.render
        action, pos = prompt
        do_action(action, pos)
      rescue => err
        puts err.message
      end
    end

    @board.render
    if @board.cleared?
      puts "You won!"
    elsif @board.bomb_revealed?
      puts "Aww..."
    end
  end

  def prompt
    puts
    puts "Enter an action, a row and column (e.g., 'r 2 5')"
    puts "Actions:"
    puts " r - reveal"
    puts " f - flag"
    action, *pos = gets.chomp.downcase.split
    raise "invalid action" unless action == 'r' || action == 'f'
    raise "invalid pos" unless pos.length == 2
    begin
      pos = pos.map { |p| Integer(p) }
    rescue
      raise "invalid pos"
    end
    [action, pos]
  end

  def do_action(action, pos)
    case action
    when 'r'
      @board.reveal(pos)
    when 'f'
      @board.toggle_flag(pos)
    end
  end
end
