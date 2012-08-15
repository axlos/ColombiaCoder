class RemoveCompanyLogoImageUrlToJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :company_logo_image_url
  end

  def down
  end
end
