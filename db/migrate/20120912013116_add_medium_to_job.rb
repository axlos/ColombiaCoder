class AddMediumToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :company_logo_medium, :string
  end
end
