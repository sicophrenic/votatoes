#-*- coding: utf-8 -*-#
class Tmdbobj < ActiveRecord::Base
  attr_accessible :tmdb_id, :name, :description, :image_url, :imdb_id

  def img_src
    "http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w185#{image_url}"
  end

  def external_link
    "http://www.imdb.com/title/#{imdb_id}"
  end
end
