class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :company_name, :null => false
      t.string :company_web_site
      t.string :company_logo_image_url
      t.text :company_description, :null => false
      t.string :job_title, :null => false
      t.text :job_description, :null => false
      t.references :city
      t.boolean :salary_negotiable, :default => 0
      t.integer :salary_range_ini, :default => 2000000
      t.integer :salary_range_fin, :default => 3500000
      t.boolean :experience_required, :default => 1 
      t.boolean :resume_directly, :default => 1
      t.string :email_address
      t.text :application_details

      t.timestamps
    end
    add_index :jobs, :city_id
  end
end
