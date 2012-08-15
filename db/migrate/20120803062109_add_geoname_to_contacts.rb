class AddGeonameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :geoname, :string
  end
end
