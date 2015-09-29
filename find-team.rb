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
  attr_accessor :players
  attr_accessor :quarterbacks
  attr_accessor :running_backs
  attr_accessor :wide_receivers
  attr_accessor :tight_ends
  attr_accessor :kickers

  def initialize(players)
    @players = players
  end

  def quarterbacks
    @players.map {|player| player if player.position == 'QB'}.compact
  end

  def running_backs 
    @players.map {|player| player if player.position == 'RB'}.compact
  end

  def wide_receivers
    @players.map {|player| player if player.position == 'WR'}.compact
  end

  def tight_ends
    @players.map {|player| player if player.position == 'TE'}.compact
  end 

  def kickers
    @players.map {|player| player if player.position == 'K'}.compact
  end

  def get_qb
    qbs = quarterbacks.collect do |qb| 
      price_per_point = (qb.salary / qb.fppg) if qb.salary.nonzero? && qb.fppg.nonzero?
       {name: qb.name, price_per_point: price_per_point}
    end
    qbs = qbs.sort {|a,b| a[:price_per_point] <=> b[:price_per_point] }
  end

end

class Player
  attr_accessor :id
  attr_accessor :position 
  attr_accessor :name
  attr_accessor :fppg
  attr_accessor :played_count
  attr_accessor :salary

  def initialize(opts)
    @id = opts[:id]
    @position = opts[:position]
    @name = opts[:name]
    @fppg = opts[:fppg]
    @played_count = opts[:played_count]  
    @salary = opts[:salary]
  end
end

players = []

CSV.foreach("./FanDuel-NFL-2015-10-01-13125-players-list.csv") do |row|
  id = row[0].to_i
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

list.get_qb
