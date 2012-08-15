class AddGeonameIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :geoname_id, :string
  end
end
