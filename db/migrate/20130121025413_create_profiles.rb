class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :full_name
      t.text :summary
      t.string :professional_headline
      t.integer :experience

      t.timestamps
    end
  end
end
