class Vote < ActiveRecord::Base
  attr_accessible :user_id, :votato_id, :vote_type

  before_save :validate_plant_or_pluck, :on => :save

  belongs_to :user
  belongs_to :votato

  def self.add_plant(user, votato)
    if vote = Vote.find_or_initialize_by(
                :user_id => user.id,
                :votato_id => votato.id)
      if vote.vote_type == Votato::PLANT
        # User has aready voted up on this votato once
        return false
      else
        # User is adding a new vote or is changing his/her vote
        vote.vote_type = Votato::PLANT
        if vote.save
          # Increment the count on the votato
          votato.total += 1
          votato.save
        else
          return false
        end
      end
    end
  end

  def self.add_pluck(user, votato)
    if vote = Vote.find_or_initialize_by(
                :user_id => user.id,
                :votato_id => votato.id)
      if vote.vote_type == Votato::PLUCK
        # User has aready voted down on this votato once
        return false
      else
        # User is adding a new vote or is changing his/her vote
        vote.vote_type = Votato::PLUCK
        if vote.save
          # Increment the count on the votato
          votato.total -= 1
          votato.save
        else
          return false
        end
      end
    end
  end

  def validate_plant_or_pluck
    vote_type.in? [Votato::PLANT, Votato::PLUCK]
  end
end