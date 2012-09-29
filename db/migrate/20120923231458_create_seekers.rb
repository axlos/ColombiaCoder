class CreateSeekers < ActiveRecord::Migration
  def change
    create_table :seekers do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :cover_letter, :null => false
      t.references :job

      t.timestamps
    end
    add_index :seekers, :job_id
  end
end