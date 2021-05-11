require 'yaml'
require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  def play(save_file)
    if save_file.nil?
      @board.seed
    else
      begin
        self.load(save_file)
      rescue => err
        puts err.message
        return
      end
    end

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

  def save
    serialized_board = @board.to_yaml
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('./saves/save', 'w+') { |f| f.write(serialized_board) }
  end

  def load(save_file)
    begin
      content = File.readlines(save_file)
      @board = YAML::load(content.join)
    rescue Errno::ENOENT
      raise "couldn't read file `#{save_file}`"
    rescue Errno::EACCES
      raise "permission denied: `#{save_file}`"
    rescue Psych::SyntaxError
      raise "couldn't load data from `#{save_file}`"
    rescue => err
      puts "something else went wrong..."
      puts err.backtrace
      raise err
    end
  end

  def prompt
    puts
    puts "Enter an action, a row and column (e.g., 'r 2 5')"
    puts "Actions:"
    puts " r - reveal"
    puts " f - flag"
    puts " s - save"
    action, *pos = gets.chomp.downcase.split
    [action, pos]
  end

  def parse_pos(pos)
    raise "invalid pos" unless pos.length == 2
    begin
      pos.map { |p| Integer(p) }
    rescue
      raise "invalid pos"
    end
  end

  def do_action(action, pos)
    case action
    when 'r'
      @board.reveal(parse_pos(pos))
    when 'f'
      @board.toggle_flag(parse_pos(pos))
    when 's'
      save
    else
      raise 'invalid action'
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  save_file = ARGV.shift
  g = Game.new
  g.play(save_file)
end
