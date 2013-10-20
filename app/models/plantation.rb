class Plantation < ActiveRecord::Base
  attr_accessible :name, :media, :privacy

  validate :media_check, :on => :create
  validate :privacy_check, :on => :create

  belongs_to :user

  has_many :votatos

  def votatoes
    votatos
  end

  def last_updated_at
    time_diff(votatos.collect(&:updated_at).sort.last || updated_at)
  end

  def media_check
    return false unless media.in?(['Movie', 'TV'])
  end

  def privacy_check
    return false unless privacy.in?(['Public', 'Private'])
  end

  def time_diff(time)
    diff = Time.now.in_time_zone('UTC') - time.in_time_zone('UTC')
    if diff < 300
      'Less than 5 minutes ago.'
    else
      diff /= 60
      if diff < 60
        "#{diff.to_int} minutes ago."
      else
        diff /= 60
        if diff < 24
          "#{diff.to_int} hours ago."
        else
          'Holy shit where have you been.'
        end
      end
    end
  end
end
