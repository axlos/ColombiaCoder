module JobsHelper

  # Listado de ofertas de trabajo
  def jobs(jobs)
        raw(
          jobs.collect do |job|
            content_tag :dl do
                content_tag(:dt, (link_to job.job_title, job_path(job)))+
                content_tag(:dd, (link_to job.company_name, job_path(job)))+
                content_tag(:dd, content_tag(:em, (job.geoname)))
            end
          end.join
        )
  end
  
  # Tipos de oferta de trabajo
  def setup_jobs(jobs)
    returning(jobs) do |t|
      if t.job_types.empty?
        t.job_types.build
      end
    end
  end

  # Estado de oferta laboral
  def status (job)
    content_tag :span, :class => (case job.status when 1 then 'label label-important' when 2 then 'label label-success' when 3 then 'label' end) do
      case job.status
        when 1 
          'No Publicado'
        when 2
          'Publicado'
        when 3
          'Finalizado'
      end
    end
  end
  
end
