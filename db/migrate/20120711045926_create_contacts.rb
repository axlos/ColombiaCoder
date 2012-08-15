class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :full_name, :null => false
      t.string :email, :null => false
      t.string :company, :null => false
      t.string :web_site, :null => false
      t.string :street_address
      t.references :city
      t.string :phone

      t.timestamps
    end
    add_index :contacts, :city_id
  end
end
