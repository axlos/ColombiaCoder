class Contact < ActiveRecord::Base
  
  belongs_to :user, :polymorphic => true
  
  attr_accessible :company, :email, :full_name, :phone, :street_address, :web_site, :location
  
  validates :email, :email => true, :uniqueness => { :case_sensitive => false }
 
end
