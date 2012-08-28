class Job < ActiveRecord::Base
  
  # Dias para que una oferta laboral caduque
  DAYS_EXPIRE = 30

  # Estados de las ofertas laborales
  DEFAULT = 1
  POST = 2
  EXPIRE = 3
  
  belongs_to :user
  has_many :technologies, dependent: :destroy, :inverse_of => :job
  has_and_belongs_to_many :job_types

  #reject_if evita que se envien tecnolias en blanco
  accepts_nested_attributes_for :technologies, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }

  attr_accessible :location, :application_details, :company_description, :company_logo, :company_name, :company_web_site, :email_address, :no_experience_required, :job_description, :job_title, :resume_directly, :salary_negotiable, :salary_range_fin, :salary_range_ini, :status, :user_id, :job_type_ids, :technologies_attributes, :technology_ids
    
  validates :company_name, :company_description, :job_title, :location, :presence => true
  validates_format_of :company_web_site, :with => URI::regexp(%w(http https))
  
  has_attached_file :company_logo, :styles => { :medium => ["260x180>", :png], :thumb => ["160x120>", :png] }
  
  validates_attachment :company_logo, :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }, :size => { :in => 0..200.kilobytes }

  default_scope order('created_at desc')
  scope :last_jobs, lambda { |num = nil| order('created_at desc').limit(num) }
  scope :urgent_jobs, lambda { |num = nil| order('created_at asc').limit(num) }
  scope :posted, where( status: 2 )
  scope :recent, order('created_at desc' )
  
  searchable :auto_index => true, :auto_remove => true do
    # fulltext search location
    text :location, :boost => 5
    # fulltext skills
    text :technologies, :boost => 5 do
      technologies.map { |skill| skill.name }
    end
    # rangos salariales
    integer :salary_range_ini
    integer :salary_range_fin
    # salario negociable
    boolean :salary_negotiable
    # estado de oferta laboral
    integer :status
    # tipos de contrato
    integer :job_type_ids, :multiple => true
    # fecha de creacion
    time :created_at
    # nombre de compania
    string :company_name
    # requiere experiencia
    boolean :no_experience_required
  end
  
  # Seleccionar alguna oferta laboral donde la empresa haya subido un logo y tengo ofertas laborales activas
  def self.random_company_with_logo
    ids = connection.select_all("select id from jobs where company_logo_file_name is not null and status = 2")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
  
  # Copia la informacion de la ultima empresa creada
  def copy_company_information(job_from)
    # TODO: implementar
  end
  
  def expire
    # Solo si la oferta laboral esta publicada, verificar si hay que finalizarla
    if POST == status
      # verificar si ya pasaron los DAYS_EXPIRE para caducar la oferta
      days = (Time.zone.now - self.created_at).to_i / 1.day      
      # ya caduco la oferta laboral?
      if days >= DAYS_EXPIRE
        self.update_attribute(:status, EXPIRE)
      end
    end
  end
 
end