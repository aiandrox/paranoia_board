class StaticPagesController < ApplicationController
  before_action :set_user

  def top
    
  end

  private
  
  def set_user
    unless current_user
      user = User.create!
      remember(user)
    end
  end
end
