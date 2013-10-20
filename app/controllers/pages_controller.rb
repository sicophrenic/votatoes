class PagesController < ApplicationController
  def root
    if user_signed_in?
      redirect_to plantations_path
    end
  end
end
