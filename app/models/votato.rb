#-*- coding: utf-8 -*-#
class Votato < ActiveRecord::Base
  attr_accessible :total, :obj_id

  belongs_to :plantation

  has_many :votes

  PLANT = '+'
  PLUCK = '-'

  def obj
    if media_type == 'TV'
      Tvdbobj.find(obj_id)
    elsif media_type == 'Movie'
      Tmdbobj.find(obj_id)
    end
  end

  def media_type
    plantation.media
  end

  def self.generate_random_id(size = 8)
    chrs = [('a'..'z'), ('A'..'Z')].map { |c| c.to_a }.flatten
    string = (0...size).map{ chrs[rand(chrs.length)] }.join
  end
end
