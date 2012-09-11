class AddLocationToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :location, :string, :null => false, :default => ''
  end
end
