class AddCompanyLogoUrlToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :company_logo_url, :string
  end
end
