class JobsController < ApplicationController
  
  include ActionView::Helpers::DateHelper

  before_filter :authenticate_user!, :except => [:show, :index, :apply]

  # GET /jobs
  def index
    # contruir objeto para inicial el formulario
    params[:job]||= {}
    @job = Job.new(params[:job])
    # Si no hay tipos de trabajo seleccionados, selecciona todos por defecto
    @job.job_types = JobType.all unless params[:job][:job_type_ids].present?
    
    search = Job.search do
      # buscar por nombre de Localizacion
      fulltext I18n.transliterate params[:job][:location] if params[:job][:location].present? do
        fields(:location)
      end
      # buscar por skills
      fulltext params[:skill] do
        fields(:technologies)
        fields(:job_title)
        fields(:job_description)
      end
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
      # si no hay ningun orden por defecto ordenamos por la mas reciente
      order_by :created_at, :desc unless params[:order].present?
      # paginacion
      paginate :per_page => 20
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
    # verificar si ya expira la oferta laboral
    @job.expire
    # visualizar mensaje de expiracion
    if Job::EXPIRE == @job.status
       # TODO: Enviar correo a la empresa de que finalizo la oferta, solo si la empresa esta enterado
       flash[:expire] = "<strong>Ups!</strong> esta oferta laboral caduco hace #{distance_of_time_in_words(Time.now, @job.created_at)}".html_safe
    end
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
        @job.company_name = job_last.company_name
        @job.company_web_site = job_last.company_web_site
        @job.company_logo_url = job_last.company_logo_url
        @job.application_details = job_last.application_details if job_last.application_details
        @job.resume_directly = job_last.resume_directly
      end
      if current_user.email
        # verificar si el usuario tiene informacion de contacto
        @job.email_address = current_user.contact.email
        @job.location = current_user.contact.location
      end
    end
  end
  
  # POST /jobs
  def create
    # guardar los skills en una variable temporal
    array_skills = Array.new(params[:job][:technology_ids])
    # borrar los skills enviados como parametros
    params[:job][:technology_ids].clear
    
    # Referenciar el usuario en session
    @job = Job.new(params[:job])
    # quitar tildes en location
    @job.location = I18n.transliterate @job.location
    @job.user = current_user
    
    if @job.save
      # asociar los skills a el job creado 
      params_skills(array_skills, @job.id)
      # Previsualizar la oferta de empleo
      if params[:preview_button]
        redirect_to :action => 'show', :id => @job.id
      else
        redirect_to admin_jobs_path(@job.id), notice: 'Oferta laboral creada con exito.'
      end
    else
      render action: "new"
    end
  end

  # PUT /jobs/1
  def update
    @job = Job.find(params[:id])
    # editar los skills enviandos como parametros
    params[:job][:technology_ids] = params_skills(params[:job][:technology_ids], @job.id)
    # quitar tildes en location
    params[:job][:location] = I18n.transliterate params[:job][:location]
    
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
    job = update_status(params[:id], 2)
    if job
      # Twitter oferta laboral
      job.tweet!
      # redireccionar oferta laboral
      redirect_to admin_jobs_url
    else
      render action: "show"
    end
  end
  
  # PUT /jobs/1/expire
  def expire
    # Cambiar de estado a finalizada
    if update_status(params[:id], 3)
      redirect_to admin_jobs_url
    else
      render action: "show"
    end
  end
  
  def apply
    @job = Job.new(params[:job])
    @seeker = @job.seekers.first
    @seeker.job_id = params[:job][:id]
    
    if @seeker.save
      # enviar resume adjunto
      JobMailer.apply_now(@job, @seeker).deliver
      redirect_to job_path(@seeker.job_id), notice: "<i class='icon-thumbs-up'></i> Gracias por aplicar a la oferta laboral!".html_safe
      # guardar cookies de datos de envio
      cookies.permanent[:name] = @seeker.name
      cookies.permanent[:email] = @seeker.email
      cookies.permanent[:cover_letter] = @seeker.cover_letter
    else
      redirect_to job_path(@seeker.job_id), alert: "<i class='icon-warning-sign'></i> Por favor, verifique los datos ingresados e intente nuevamente!".html_safe
    end
  end
  
  private
  def update_status(job_id, status)
    @job = Job.find(job_id)
    # Cambiar de estado la oferta laboral
    @job.update_attribute(:status, status)
    # retornar oferta laboral
    @job
  end
  
  def params_skills(params_skills, job_id)
    skills_ids = Array.new
    skills_new = Array.new
          
    params_skills.each do |skill|
      unless skill.empty?      
        # verificar que no sea un id, si es un string es por que no existe la tecnologia
        if skill.numeric?
          # guardar el id de skill en un arreglo temporal
          skills_ids << skill
        else
          skills_new << Technology.find_or_create_by_job_id_and_name(job_id, skill).id
        end
      end
    end

    # borrar todos los parametros enviados para las tecnologias    
    params_skills.clear
    # retornar los skills creados y referenciados a los existentes
    skills_ids = skills_ids | skills_new
  end
  
end