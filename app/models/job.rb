require 'open-uri'

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
  
  # desactivado adjuntar archivos, logotipo de la empresa
  # has_attached_file :company_logo, :styles => { :medium => ["260x180>", :png], :thumb => ["160x120>", :png] }
  # validar tipo de archivo de imagen y tamanio
  # validates_attachment :company_logo, :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }, :size => { :in => 0..200.kilobytes }
   
  #reject_if evita que se envien tecnolias en blanco
  accepts_nested_attributes_for :technologies, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }

  attr_accessible :location, :application_details, :company_description, :company_name, :company_web_site, :email_address, :no_experience_required, :job_description, :job_title, :resume_directly, :salary_negotiable, :salary_range_fin, :salary_range_ini, :status, :user_id, :job_type_ids, :technologies_attributes, :technology_ids, :company_logo_url
    
  validates :job_title, :length => { :maximum => 80 }
  validates :location, :length => { :maximum => 20 }
  
  validates :company_name, :company_description, :job_title, :job_description, :location, :job_types, :presence => true
  
  # Validar formatos de URL si existen
  validates_format_of :company_web_site, :with => URI::regexp(%w(http https)), :if => :company_web_site?
  validates_format_of :company_logo_url, :with => URI::regexp(%w(http https)), :if => :company_logo_url?
  
  # Validar como aplicar a la oferta de empleo
  validates :email_address, :email => true, :if => :resume_directly?
  validates_presence_of :application_details, :if => :application_details?

  scope :last_jobs, lambda { |num = nil| order('created_at desc').limit(num) }
  scope :urgent_jobs, lambda { |num = nil| order('created_at asc').limit(num) }
  scope :posted, where(status: 2)
  scope :recent, order('created_at desc')
  
  def resume_directly?
    if self.resume_directly
       self.email_address.blank?
    end
  end
  
  def application_details?
    unless self.resume_directly
       self.application_details.blank?
    end
  end

  searchable :auto_index => true, :auto_remove => true do
    # fulltext search location
    text :location, :boost => 5
    text :job_title
    text :job_description
    
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
  
  # Seleccionar alguna oferta laboral donde la empresa tenga un logo y tengo ofertas laborales activas
  def self.random_company_with_logo
    ids = connection.select_all("select id from jobs where company_logo_url is not null and status = 2")
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
  
  def tweet!
    # Twitter oferta laboral
    tweet_desc = "#Empleo en @colombiadev #{job_title} en #{location}"
    shrunk_url = Job.tiny_url(134 - tweet_desc.length, "http://www.colombiacoder.com/jobs/#{id}")
    
    if tweet_desc.length > 134 - shrunk_url.length
      tweet_desc = tweet_desc[0...(134 - shrunk_url.length)] + '...'
    end
    tweet = "#{tweet_desc} #{shrunk_url}"
    Twitter.update tweet
  end
 
  def self.tiny_url(available_length, url)
    string = "http://is.gd/api.php?longurl=" + CGI::escape(url)
    open(string).read.strip
  rescue StandardError => e
    puts "Error in tiny_url: #{e.message}\n#{e.backtrace}"
  end
  
end