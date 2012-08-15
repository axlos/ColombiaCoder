class AddGeonameIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :geoname_id, :string
  end
end
