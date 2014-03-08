class Profile < ActiveRecord::Base
  
  has_many :technologies, :dependent => :destroy, :inverse_of => :profile
  accepts_nested_attributes_for :technologies, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  attr_accessible :experience, :full_name, :professional_headline, :summary, :technologies_attributes, :technology_ids
    
  before_save :clear_skills
  after_save :add_skills
  
  def clear_skills
    # guardar los skills en una variable temporal
    @array_skills = technology_ids
    # borrar los skills del hash para que no sean creados cuando se guarda el perfil
    technology_ids = nil
  end

  def add_skills
    # asociar los skills al perfil creado 
    Technology.params_skills(@array_skills, id, 2)
  end
  
  
end