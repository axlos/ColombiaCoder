require 'net/http'
require 'addressable/uri'

class JobMailer < ActionMailer::Base
  
  INFO_EMAIL = "ColombiaCoder.com <info@colombiacoder.com>"
  
  default from: INFO_EMAIL 
  
  def apply_now(job, seeker)
    @job = job
    @seeker = seeker
    
    uri = Addressable::URI.parse(seeker.authenticated_url)
    # URI de documento almacenado en S3
    res = Net::HTTP.start(uri.host, uri.port) { |http| 
      request = Net::HTTP::Get.new uri.request_uri
      http.request request
    }
    # adjuntar resume
    attachments[seeker.resume_file_name] = res.body
    # enviar hoja de vida
    mail(:to => @job.email_address, :bcc => [@seeker.email, INFO_EMAIL], :subject => "Aspirante para #{@job.job_title}")
  end
  
end
