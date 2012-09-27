module JobsHelper

  # Listado de ofertas de trabajo
  def jobs(jobs)
    raw(
      jobs.collect do |job|
        content_tag :dl do
            content_tag(:dt, (link_to job.job_title, job_path(job)))+
            content_tag(:dd, (link_to job.company_name, jobs_path({:company_name => job.company_name})))+
            content_tag(:dd, content_tag(:em, (job.location)))
        end
      end.join
    )
  end
  
  # previsualizacion de oferta de trabajo
  def job_preview(job)
    content_tag :dl do
        # Descripcion de distancia de tiempo en palabras
        content_tag(:span, "Hace #{distance_of_time_in_words(Time.now, job.created_at)}", :class => 'pull-right') +
        content_tag(:dt, (link_to job.job_title, job) + " - #{job.company_name}") + 
        content_tag(:dd, content_tag(:em, job.location)) +
        # Truncar descripcion de trabajo, quitar tags HTML
        content_tag(:dd, content_tag(:span, truncate(strip_tags(job.job_description), :length => 130), :class => 'muted')) +
        content_tag(:dd, job.job_types.to_sentence) + 
        content_tag(:dd, 
          raw(
            job.technologies.collect do |skill|
              content_tag(:span, "#{skill.name}", :class => 'label label-info') + ' '
            end.join
          )
        ) +
        content_tag(:hr)
    end
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
