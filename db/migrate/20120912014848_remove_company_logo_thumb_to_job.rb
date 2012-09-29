class RemoveCompanyLogoThumbToJob < ActiveRecord::Migration
  def up
    remove_column :jobs, :company_logo_thumb
  end

  def down
  end
end
