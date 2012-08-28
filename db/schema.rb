# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120826194009) do

  create_table "contacts", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "company"
    t.string   "web_site"
    t.string   "street_address"
    t.string   "phone"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "user_id"
    t.string   "location",       :default => "", :null => false
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "job_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "job_types_jobs", :id => false, :force => true do |t|
    t.integer "job_id"
    t.integer "job_type_id"
  end

  add_index "job_types_jobs", ["job_id", "job_type_id"], :name => "index_job_types_jobs_on_job_id_and_job_type_id"
  add_index "job_types_jobs", ["job_type_id", "job_id"], :name => "index_job_types_jobs_on_job_type_id_and_job_id"

  create_table "jobs", :force => true do |t|
    t.string   "company_name",                                   :null => false
    t.string   "company_web_site"
    t.text     "company_description",                            :null => false
    t.string   "job_title",                                      :null => false
    t.text     "job_description",                                :null => false
    t.boolean  "salary_negotiable",         :default => false
    t.integer  "salary_range_ini",          :default => 2000000
    t.integer  "salary_range_fin",          :default => 3500000
    t.boolean  "resume_directly",           :default => true
    t.string   "email_address"
    t.text     "application_details"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "company_logo_file_name"
    t.string   "company_logo_content_type"
    t.integer  "company_logo_file_size"
    t.datetime "company_logo_updated_at"
    t.integer  "status",                    :default => 1,       :null => false
    t.integer  "user_id"
    t.boolean  "no_experience_required",    :default => false
    t.string   "location",                  :default => "",      :null => false
  end

  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "jobs_job_types", :id => false, :force => true do |t|
    t.integer "job_id"
    t.integer "job_type_id"
  end

  add_index "jobs_job_types", ["job_id", "job_type_id"], :name => "index_jobs_job_types_on_job_id_and_job_type_id"
  add_index "jobs_job_types", ["job_type_id", "job_id"], :name => "index_jobs_job_types_on_job_type_id_and_job_id"

  create_table "technologies", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "job_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "technologies", ["job_id"], :name => "index_technologies_on_job_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
