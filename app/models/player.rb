class Player < ActiveRecord::Base
  has_many :wins, class_name:  "Game", foreign_key: :winner_id
  has_many :losses, class_name: "Game", foreign_key: :loser_id

  has_many :games, :finder_sql => Proc.new { "SELECT * FROM games WHERE winner_id = #{id} or loser_id = #{id} ORDER BY created_at desc" }

  def percentage
    wins.length.to_f / games.length * 100
  end

  def self.leaderboard
    select("(select count(*) from games where winner_id = players.id) / (select count(*) from games where loser_id = players.id or winner_id = players.id) as percentage").select("*")
  end
end
