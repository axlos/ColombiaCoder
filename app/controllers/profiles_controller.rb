class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end
  
  # POST /profiles
  # POST /profiles.json
  def create
    # verificar si el usuario esta logeado
    if user_signed_in?
      # si es nil el valor enviado como parametro se obtiene de session
      params[:profile] ||= session[:profile]
      # Referenciar el usuario en session
      @profile = Profile.new(params[:profile])
      if @profile.save
        session[:profile] = nil
        redirect_to @profile, notice: 'Su perfil fue creado satisfactoriamente.'
      end
    else      
      # Guardar el perfil creado en session
      session[:profile] = Profile.new(params[:profile])
      # No esta autenticado el usuario, redireccionar para crear cuenta
      redirect_to new_user_registration_path
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])

    if @profile.update_attributes(params[:profile])
      redirect_to @profile, notice: 'Profile was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to profiles_url
  end
end
