class AddGeonameToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :geoname, :string
  end
end
