class Technology < ActiveRecord::Base
  belongs_to :job
  attr_accessible :name
  
  validate :name, :presence => true
end
