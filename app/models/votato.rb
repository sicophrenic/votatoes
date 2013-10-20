class Votato < ActiveRecord::Base
  attr_accessible :total, :series_id

  belongs_to :plantation

  def title
    "#{plantation.media}-#{series_id}"
  end

  def self.generate_random_id(size = 8)
    chrs = [('a'..'z'), ('A'..'Z')].map { |c| c.to_a }.flatten
    string = (0...size).map{ chrs[rand(chrs.length)] }.join
  end
end
