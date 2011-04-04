class PagesController < ApplicationController
  def home
  end

  def contact
    @title = 'Contact'
  end

  def about
    @title = 'About'
  end

  def help
    @title = 'Help'
  end
  
  def recover
    if signed_in?
      redirect_to current_user
    else
      @title = 'Recover your password'
    end
  end

end
