class StaticPagesController < ApplicationController
  def coming_soon
  end
  
  def home
  end

  def about
  end

  def resources
  end

  def stories
  end

  def public_speaking
  end

  def community
    @subpath = params[:subpath]
  end

  def events
  end

  def policies
  end
end
