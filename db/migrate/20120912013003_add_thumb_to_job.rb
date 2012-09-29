class AddThumbToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :company_logo_thumb, :string
  end
end
