class AddDefaultValueToContact < ActiveRecord::Migration
  def change
    change_column :contacts, :full_name, :string, :null => true 
    change_column :contacts, :email, :string, :null => true
    change_column :contacts, :company, :string, :null => true
    change_column :contacts, :web_site, :string, :null => true
  end
end