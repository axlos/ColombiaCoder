# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController

  # se sobreescribe el metodo de registrar cuenta para crear la informacion de contacto
  def create
    build_resource
    # Crear informacion de contacto
    resource.build_contact
    # Por defecto se ingresa el email del usuario a la informacion de contacto
    resource.contact.email = resource.email

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        # determinar si existe la session temporal para guadar el perfil, para redireccionar a guardar perfil
        if session[:profile].present?
          # obtener profile de session
          profile = session[:profile]
          # guardar el perfil
          if profile.save
            # borrar variable en session
            session[:profile] = nil
            # redireccionar a lista de perfiles
            redirect_to profiles_path, notice: 'Ups! en estos momentos no podemos registrar su perfil, intente mas tarde.'
          else
            # redireccionar a lista de perfiles
            redirect_to profiles_path, notice: 'Su perfil fue creado satisfactoriamente.'
          end
        else
          respond_with resource, :location => after_sign_up_path_for(resource) unless session[:profile].present?
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end 