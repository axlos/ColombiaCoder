class JobType < ActiveRecord::Base
  
  has_and_belongs_to_many :jobs
  
  attr_accessible :name
  
  validates :name, :presence => true
  
  def to_s
    name
  end
  
end
