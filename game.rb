require 'yaml'
require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  def init_board(save_file)
    if save_file.nil?
      @board.seed
    else
      begin
        self.load(save_file)
      rescue => err
        puts err.message
        exit
      end
    end
  end

  def play
    until @board.game_over?
      begin
        @board.render
        action, pos = prompt
        do_action(action, pos)
      rescue => err
        puts err.message
      end
    end
  end

  def start(save_file)
    init_board(save_file)
    play

    @board.render
    if @board.cleared?
      puts "You won!"
    elsif @board.bomb_revealed?
      puts "Aww..."
    end
  end

  def save(save_file)
    save_file = 'save' if save_file.empty?

    serialized_board = @board.to_yaml
    begin
      Dir.mkdir('saves') unless Dir.exist?('saves')
      File.open("./saves/#{save_file}", 'w+') do
        |f| f.write(serialized_board)
      end
      puts "Game saved: `saves/#{save_file}`"
    rescue IOError
      raise "coundn't save file: `#{save_file}`"
    rescue Errno::EACCES
      raise "permission denied: `#{save_file}`"
    rescue => err
      puts "something else went wrong..."
      p err.backtrace
      raise err
    end
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
    action, *args = gets.chomp.downcase.split
    [action, args]
  end

  def parse_pos(pos)
    raise "invalid pos" unless pos.length == 2
    begin
      pos.map { |p| Integer(p) }
    rescue
      raise "invalid pos"
    end
  end

  def do_action(action, args)
    case action
    when 'r'
      @board.reveal(parse_pos(args))
    when 'f'
      @board.toggle_flag(parse_pos(args))
    when 's'
      save(args.join(' '))
    else
      raise 'invalid action'
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  save_file = ARGV.shift
  g = Game.new
  g.start(save_file)
end
