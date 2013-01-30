require 'redis'
$redis = Redis.new

class RedisHanoi
  
  # RedisHanoi.next_id gibt bei jedem Aufruf eine neue ID zurück
  def self.next_id
    $redis.incr('hanoi:next_game_id')
  end

  # die ID in der Datenbank
  attr_reader :game_id

  # RedisHanoi.new() erzeugt ein neues Turm von Hanoi
  # RedisHanoi.new(123) lädt den Spielstand mit der ID 123
  def initialize(game_id=nil)
    @game_id = game_id || RedisHanoi.next_id
    
    # falls alle Staebe leer sind
    if (is_empty?(:a) && is_empty?(:b) && is_empty?(:c))
      # lege einen neue Liste an
      $redis.lpush key(:a), [0, 1, 2]
    end
  end
  
  # gibt den schlüssel "hanoi:<game_id>:<rod>" zurück
  def key(sym)
    "hanoi:#{@game_id}:#{sym}"
  end
  
  # gibt die Liste für einen Stab zurück
  # und sorgt für die richtige Reihenfolge
  def rod(name)
    $redis.lrange(key(name), 0, -1).reverse
  end
  
  # der Stab ist leer
  def is_empty?(rod)
    # wenn er nicht existiert
    not $redis.exists(key(rod))
  end
  
  # gibt das letzte Element / die oberste Scheibe zurück
  def top(rod)
    $redis.lindex(key(rod), 0)
  end

  # ist der zug erlaubt?
  def allowed_move?(from, to)
    return false unless rod?(from) && rod?(to)
    return false if is_empty?(from)
    return true  if is_empty?(to)
    top(to) < top(from)
  end
  
  # mache einen zug von Stab from nach Stab to
  def move(from, to)
    raise Exception.new unless allowed_move?(from, to)
    disc = $redis.lpop(key(from))
    $redis.lpush(key(to), disc)
  end
  
  # ist der gesamte Turm auf dem Stab c?
  def finished?
    is_empty?(:a) && is_empty?(:b) && ! is_empty?(:c)
  end  

  # ist dies ein gültiger Stab?
  def rod?(rod)
    ['a', 'b', 'c'].member? rod.to_s
  end
  
end