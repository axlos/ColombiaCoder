class JobsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /jobs
  def index
    @jobs = Job.all
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
  
  # GET /jobs/
  def preview
    @job = session[:job_params]  
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end
  
  # GET /jobs/new
  def new
    session[:job_params] ||= {}
    @job = Job.new(session[:job_params])
  end
  
  # POST /jobs
  def create
    # merge entre los parametros enviados como post y los valores de session si existen
    session[:job_params].deep_merge!(params[:job]) if params[:job]
    # crear nuevo job
    @job = Job.new(session[:job_params])
    # previsualizar la oferta de empleo
    if params[:preview_button]
      render "preview"
    else
      @job.user = current_user
      if @job.save
        session[:job_params] = session[:job_auth] = nil
        redirect_to admin_jobs_path(@job.id), notice: 'Oferta laboral creada.'
      else
        render action: "new"
      end
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