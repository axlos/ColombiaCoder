class AddNotificationToSeeker < ActiveRecord::Migration
  def change
    add_column :seekers, :notification, :boolean, :default => true
  end
end