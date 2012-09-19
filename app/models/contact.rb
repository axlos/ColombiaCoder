class Contact < ActiveRecord::Base
  
  belongs_to :user, :polymorphic => true
  
  attr_accessible :company, :email, :full_name, :phone, :street_address, :web_site, :location
  
  validates :email, :email => true, :uniqueness => { :case_sensitive => false }
  
  # Validar formatos de URL si existen
  validates_format_of :web_site, :with => URI::regexp(%w(http https)), :if => :web_site?
 
end
