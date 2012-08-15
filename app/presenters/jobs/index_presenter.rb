class Jobs::IndexPresenter
  
  def last_jobs
    Job.posted.last_jobs(4)
  end
  
  def urgent_jobs
    Job.posted.last_jobs(4)
  end

end