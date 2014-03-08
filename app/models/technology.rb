class Technology < ActiveRecord::Base
  
  belongs_to :job 
  belongs_to :profile
  
  attr_accessible :name, :job_id, :profile_id
  
  validate :name, :presence => true
  
  default_scope :order => 'created_at'
  
  def self.top_skills(limit)
    # seleccionar las tecnologias mas seleccionadas y convertir resultado en un map con solo los nombres
    connection.select_all("select skill.name as name from (select name, count(*) from technologies group by name order by 2 desc limit #{limit}) as skill").map(&:values).flatten
  end
    
  def to_s
    name
  end
  
  # type = 1 referencia a la tabla job_id 
  # type = 2 referencia a la tabla profile_id
  def self.params_skills(params_skills, ref_id, type)
    skills_ids = Array.new
    skills_new = Array.new
          
    params_skills.each do |skill|
      unless skill.empty?      
        # verificar que no sea un id, si es un string es por que no existe la tecnologia
        if skill.numeric?
          # guardar el id de skill en un arreglo temporal
          skills_ids << skill
        else
          # asociar el skill al job_id
          skills_new << Technology.find_or_create_by_job_id_and_name(ref_id, skill).id if type == 1
          skills_new << Technology.find_or_create_by_profile_id_and_name(ref_id, skill).id if type == 2
        end
      end
    end

    # borrar todos los parametros enviados para las tecnologias    
    params_skills.clear
    # retornar los skills creados y referenciados a los existentes
    skills_ids = skills_ids | skills_new
  end
  
end
