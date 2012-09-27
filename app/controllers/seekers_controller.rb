class SeekersController < ApplicationController

  # POST /seekers
  def create
    @seeker = Seeker.new(params[:seeker])

    respond_to do |format|
      if @seeker.save
        #JobMailer.apply_now(@seeker.job_id, params[:job_job_title], params[:job_email_address], @seeker.name, @seeker.email, @seeker.cover_letter).deliver
        #redirect_to job_path, :id => 79, :notice => "Pay attention to the road" and return 
      else
        render action: "new"
      end
    end
  end
  
  def thanks
    
  end

end
