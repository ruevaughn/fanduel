require 'csv'
require 'pry'

class Team
  attr_accessor :qb
  attr_accessor :rb1
  attr_accessor :rb2
  attr_accessor :wr1
  attr_accessor :wr2
  attr_accessor :wr3
  attr_accessor :te
  attr_accessor :k
  attr_accessor :d
  attr_accessor :salary 
  attr_accessor :salary_cap

  def initialize
    @salary_cap = 60000 
  end
end

class PlayerList
  attr_accessor :id
  attr_accessor :players
  attr_accessor :quarterbacks
  attr_accessor :running_backs
  attr_accessor :wide_receivers
  attr_accessor :tight_ends
  attr_accessor :kickers

  def initialize(players)
    @players = players
  end

  # QBS

  def quarterbacks
    @quarterbacks ||= @players.map {|player| player if player.position == 'QB'}.compact
  end

  def sorted_quarterbacks
    @sorted_quarterbacks ||= quarterbacks.map {|qb| qb if qb.price_per_point != 0 }.compact
    @sorted_quarterbacks.sort { |a,b| a.price_per_point <=> b.price_per_point}
  end

  def best_qb
    sorted_quarterbacks.first
  end

  #RBS

  def running_backs 
    @players.map {|player| player if player.position == 'RB'}.compact
  end

  def sorted_running_backs
    @sorted_running_backs ||= running_backs.map {|player| player if player.price_per_point != 0 }.compact
    @sorted_running_backs.sort { |a,b| a.price_per_point <=> b.price_per_point}
  end

  def best_rb1
    sorted_running_backs[0]
  end

  def best_rb2
    sorted_running_backs[1]
  end

  # WRS

  def wide_receivers
    @players.map {|player| player if player.position == 'WR'}.compact
  end

  def sorted_wide_receivers
    @sorted_wide_receivers ||= wide_receivers.map {|player| player if player.price_per_point != 0 }.compact
    @sorted_wide_receivers.sort { |a,b| a.price_per_point <=> b.price_per_point}
  end

  def best_wr1
    sorted_wide_receivers[0]
  end

  def best_wr2
    sorted_wide_receivers[1]
  end

  def best_wr3
    sorted_wide_receivers[2]
  end

  # TE

  def tight_ends
    @players.map {|player| player if player.position == 'TE'}.compact
  end 

  def sorted_tight_ends
    @sorted_tight_ends ||= tight_ends.map {|player| player if player.price_per_point != 0 }.compact
    @sorted_tight_ends.sort { |a,b| a.price_per_point <=> b.price_per_point}
  end

  def best_te
    sorted_tight_ends[0]
  end

  # K

  def kickers
    @players.map {|player| player if player.position == 'K'}.compact
  end

  def sorted_kickers
    @sorted_kickers ||= kickers.map {|player| player if player.price_per_point != 0 }.compact
    @sorted_kickers.sort { |a,b| a.price_per_point <=> b.price_per_point}
  end

  def best_k
    sorted_kickers[0]
  end

end

class Player
  attr_accessor :id
  attr_accessor :position 
  attr_accessor :name
  attr_accessor :fppg
  attr_accessor :played_count
  attr_accessor :salary
  attr_accessor :price_per_point

  def initialize(opts)
    @id = opts[:id]
    @position = opts[:position]
    @name = opts[:name]
    @fppg = opts[:fppg]
    @played_count = opts[:played_count]  
    @salary = opts[:salary]

    @price_per_point = price_per_point
  end

  def price_per_point 
    if self.salary.nonzero? && self.fppg.nonzero?
      (self.salary.to_f / self.fppg.to_f).round(2)
    else
      0.0 
    end

  end
end

players = []
count = 0

CSV.foreach("./FanDuel-NFL-2015-10-01-13125-players-list.csv") do |row|
  count += 1  
  next if count == 1 
  id = count - 1
  position = row[1]
  name   = "#{row[2]} #{row[3]}"   
  fppg   = row[4].to_i
  played_count = row[5].to_i
  salary = row[6].to_i

  player = {
    id: id,
    position: position,
    name: name, 
    fppg: fppg,
    played_count: played_count,
    salary: salary
  }

  player = Player.new(player)

  players << player
end

team = Team.new
list = PlayerList.new(players)

team.qb = list.best_qb
team.rb1 = list.best_rb1
team.rb2 = list.best_rb2
team.wr1 = list.best_wr1
team.wr2 = list.best_wr2
team.wr3 = list.best_wr3
team.te =  list.best_te
team.k = list.best_k

puts team.qb.name
puts team.rb1.name
puts team.rb2.name
puts team.wr1.name
puts team.wr2.name
puts team.wr3.name
puts team.te.name
puts team.k.name





