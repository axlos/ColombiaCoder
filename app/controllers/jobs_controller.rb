class JobsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /jobs
  def index
    # contruir objeto para inicial el formulario
    params[:job]||= {}
    @job = Job.new(params[:job])
    # Si no hay tipos de trabajo seleccionados, selecciona todos por defecto
    @job.job_types = JobType.all unless params[:job][:job_type_ids].present?
    
    search = Job.search do
      # Localizacion
      with(:geoname_id, params[:job_geoname_id]) if params[:job_geoname_id].present?
      # Salario negociable
      with(:salary_negotiable, params[:job][:salary_negotiable] == 'true') if params[:job][:salary_negotiable].present?
      # Rango de salarios
      with(:salary_range_ini).greater_than(params[:job_salary_range_ini]) if params[:job][:salary_negotiable] == 'false' and params[:job_salary_range_ini].present?
      with(:salary_range_fin).less_than(params[:job_salary_range_fin]) if params[:job][:salary_negotiable] == 'false' and params[:job_salary_range_fin].present?
      # solo ofertas activas
      with(:status, 2)
      # tipos de contrato
      with(:job_type_ids, params[:job][:job_type_ids]) if params[:job][:job_type_ids].present?
      # por nombre de empresa
      with(:company_name, params[:company_name]) if params[:company_name].present?
      # Si no se requiere experiencia
      with(:no_experience_required, params[:no_experience_required]) if params[:no_experience_required].present?
      # ordernar por fecha de creacion
      order_by :created_at, :desc if params[:order] == 'last'
      order_by :created_at, :asc if params[:order] == 'urgent'
      # paginacion
      paginate :per_page => 25
      paginate :page => params[:page]
    end
    @jobs = search.results
    @search_total = search.total
  end
  
  # GET /jobs
  def admin
    @jobs = current_user.jobs
    # Informacion de contacto del usuario
    @contact = current_user.contact
  end

  # GET /jobs/1
  def show
    @job = Job.find(params[:id])  
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end
  
  # GET /jobs/new@job = session[:job_params]
  def new
    @job = Job.new
    # solo si el usuario esta autenticado
    if user_signed_in?
      # verificar si existe alguna oferta laboral por defecto para traer la informacion de la empresa
      job_last = current_user.jobs.first
      if job_last
        @job.company_description = job_last.company_description
        @job.company_logo = job_last.company_logo
        @job.company_name = job_last.company_name
        @job.company_web_site = job_last.company_web_site
        if job_last.application_details
          @job.application_details = job_last.application_details
        end
      end
      if current_user.email
        # verificar si el usuario tiene informacion de contacto
        @job.resume_directly = true
        @job.email_address = current_user.contact.email
        @job.geoname_id = current_user.contact.geoname_id
        @job.geoname = current_user.contact.geoname
      end
    end
    
  end
  
  # POST /jobs
  def create
    # Referenciar el usuario en session
    @job = Job.new(params[:job])
    @job.user = current_user
    if @job.save
      # Previsualizar la oferta de empleo
      if params[:preview_button]
        redirect_to :action => 'show', :id => @job.id
      else
        redirect_to admin_jobs_path(@job.id), notice: 'Oferta laboral creada.'
      end
    else
      render action: "new"
    end
  end

  # PUT /jobs/1
  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      redirect_to @job, notice: 'Oferta laboral actualizada.'
    else
      render action: "edit"
    end
  end

  # DELETE /jobs/1
  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to admin_jobs_url
  end
  
  # PUT /jobs/1/post
  def post
    # Cambiar de estado a publicada
    if update_status(params[:id], 2)
      redirect_to admin_jobs_url
    else
      render action: "show"
    end
  end
  
  # PUT /jobs/1/close
  def close
    # Cambiar de estado a finalizada
    if update_status(params[:id], 3)
      redirect_to admin_jobs_url
    else
      render action: "show"
    end
  end
  
  # PUT /jobs/1/republish
  def republish
    # Cambiar de estado a finalizada
    if update_status(params[:id], 2)
      redirect_to admin_jobs_url
    else
      render action: "show"
    end
  end
  
  private
  def update_status(job_id, status)
    @job = Job.find(job_id)
    # Cambiar de estado la oferta laboral
    @job.update_attribute(:status, status)
  end
  
end