#-*- coding: utf-8 -*-#
class Tvdbobj < ActiveRecord::Base
  attr_accessible :series_id, :name, :description, :image_url

  def img_src
    "http://www.thetvdb.com/banners/#{image_url}"
  end

  def external_link
    "http://thetvdb.com/?tab=series&id=#{series_id}"
  end
end
