require "aws/s3"

class Seeker < ActiveRecord::Base
  belongs_to :job, :inverse_of => :seekers
  attr_accessible :name, :email, :cover_letter, :job_id, :resume, :notification

  validates :cover_letter, :email, :name, :job_id, :presence => true
  validates :email, :email => true
  
  # archivo adjunto de hoja de vida en AWS S3
  has_attached_file :resume, :storage => :s3
  #, :s3_credentials => { :bucket => ENV['S3_BUCKET_NAME'], :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  
  validates :resume, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :resume
  validates_attachment_size :resume, :less_than => 1.megabytes, :message => 'Solo archivos maximo de 1 mega'
  validates_attachment_content_type :resume, :content_type => ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  
  def authenticated_url(style = nil, expires_in = 10.minutes)
    bucket = AWS::S3::Bucket.new(resume.bucket_name)
    s3object = AWS::S3::S3Object.new(bucket, resume.path(resume.default_style))
    s3object.url_for(:read, :expires => expires_in) 
  end
  
end