class RemoveCompanyLogoMediumToJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :company_logo_medium
  end

  def down
  end
end
