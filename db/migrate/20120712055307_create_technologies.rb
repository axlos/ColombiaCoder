class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name, :null => false
      t.references :job

      t.timestamps
    end
    add_index :technologies, :job_id
  end
end
