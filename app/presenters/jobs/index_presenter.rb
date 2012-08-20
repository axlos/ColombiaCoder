class Jobs::IndexPresenter
 


  def last_jobs
    Job.posted.last_jobs(4)
  end
  
  def urgent_jobs
    Job.posted.last_jobs(4)
  end
  
  def random_company
    # Memoized, para no repertir la busqueda cada vez que se llame el random_company
    @random_company ||= Job.random_company_with_logo  
  end

end