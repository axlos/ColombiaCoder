class Technology < ActiveRecord::Base
  
  belongs_to :job 
  attr_accessible :name, :job_id
  
  validate :job, :name, :presence => true
  
  default_scope :order => 'created_at'
  
  # TODO: Mirar como mejorar para sacar los 6 skills mas ofertados
  scope :top_skilss, :limit => 6, :group => "id,name"
  
  def to_s
    name
  end
  
end
