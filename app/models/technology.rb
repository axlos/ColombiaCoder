class Technology < ActiveRecord::Base
  
  belongs_to :job 
  attr_accessible :name, :job_id
  
  validate :job, :name, :presence => true
  
  default_scope :order => 'created_at'
  
  def self.top_skills(limit)
    # seleccionar las tecnologias mas seleccionadas y convertir resultado en un map con solo los nombres
    connection.select_all("select skill.name as name from (select name, count(*) from technologies group by name order by 2 desc limit #{limit}) as skill").map(&:values).flatten
  end
    
  def to_s
    name
  end
  
end
