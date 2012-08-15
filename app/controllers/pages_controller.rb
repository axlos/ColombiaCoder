class PagesController < ApplicationController
  
  def index
    @presenter = Jobs::IndexPresenter.new
  end
    
end
