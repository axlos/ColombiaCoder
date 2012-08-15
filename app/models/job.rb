class Job < ActiveRecord::Base
  belongs_to :user
  has_many :technologies, dependent: :destroy
  has_and_belongs_to_many :job_types

  attr_accessible :application_details, :company_description, :company_logo, :company_name, :company_web_site, :email_address, :no_experience_required, :job_description, :job_title, :resume_directly, :salary_negotiable, :salary_range_fin, :salary_range_ini, :geoname_id, :geoname, :job_type_ids, :status

  validate :company_name, :company_description, :job_title, :job_description, :geoname_id, :geoname, :presence => true
  validates_format_of :company_web_site, :with => URI::regexp(%w(http https))
  
  has_attached_file :company_logo, :styles => { :medium => ["260x180#", :png], :thumb => ["160x120#", :png] }
  
  validates_attachment :company_logo, :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }, :size => { :in => 0..200.kilobytes }

  scope :last_jobs, lambda { |num = nil| order('created_at desc').limit(num) }
  scope :urgent_jobs, lambda { |num = nil| order('created_at asc').limit(num) }
  scope :posted, where( status: 2 )
  scope :recent, order('created_at desc' )
  
end