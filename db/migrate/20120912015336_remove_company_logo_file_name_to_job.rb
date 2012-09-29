class RemoveCompanyLogoFileNameToJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :company_logo_file_name
    remove_column :jobs, :company_logo_content_type
    remove_column :jobs, :company_logo_file_size
    remove_column :jobs, :company_logo_updated_at
  end

  def down
  end
end
