class Votato < ActiveRecord::Base
  attr_accessible :total, :tvdbobj_id

  belongs_to :plantation

  def tvdbobj
    Tvdbobj.find(tvdbobj_id)
  end

  def self.generate_random_id(size = 8)
    chrs = [('a'..'z'), ('A'..'Z')].map { |c| c.to_a }.flatten
    string = (0...size).map{ chrs[rand(chrs.length)] }.join
  end
end
