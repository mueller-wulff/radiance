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

ActiveRecord::Schema.define(:version => 20111113220206) do

  create_table "answers", :force => true do |t|
    t.string   "txt"
    t.integer  "student_id"
    t.integer  "question_id"
    t.boolean  "locked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 2,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "contents", :force => true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.string   "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "short_title"
    t.text     "description"
    t.integer  "parent_id"
    t.string   "language"
    t.boolean  "published",   :default => false
    t.boolean  "deprecated",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers", :force => true do |t|
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers_stitch_modules", :id => false, :force => true do |t|
    t.integer "stitch_module_id"
    t.integer "developer_id"
  end

  create_table "discussion_links", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "student_id"
    t.integer  "group_id"
    t.boolean  "completed",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", :force => true do |t|
    t.integer  "value"
    t.integer  "gradable_id"
    t.string   "gradeable_type"
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_essays", :force => true do |t|
    t.integer  "max_length"
    t.text     "txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.integer  "course_id"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "notes", :force => true do |t|
    t.string   "text"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.integer  "stitch_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
  end

  create_table "profile_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "name"
    t.string   "lastname"
    t.string   "login"
    t.datetime "last_login_at"
    t.integer  "login_count",        :default => 0,  :null => false
    t.integer  "failed_login_count", :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "tmp_passwd"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",   :default => "", :null => false
    t.integer  "role_id"
    t.string   "role_type"
  end

  add_index "profiles", ["email"], :name => "index_profiles_on_email"
  add_index "profiles", ["perishable_token"], :name => "index_profiles_on_perishable_token"

  create_table "questions", :force => true do |t|
    t.text     "txt"
    t.boolean  "multi",      :default => true
    t.string   "type"
    t.text     "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_length"
  end

  create_table "responses", :force => true do |t|
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_texts", :force => true do |t|
    t.text     "txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slideshares", :force => true do |t|
    t.text     "slide_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stitch_modules", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "course_id"
    t.boolean  "complete",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_title"
    t.integer  "position"
  end

  create_table "stitch_units", :force => true do |t|
    t.integer  "stitch_module_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
  end

  create_table "students", :force => true do |t|
    t.boolean  "activated",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutors", :force => true do |t|
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "youtubes", :force => true do |t|
    t.text     "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
