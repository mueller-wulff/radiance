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

ActiveRecord::Schema.define(:version => 20120312133511) do

  create_table "answers", :id => false, :force => true do |t|
    t.integer  "id",          :null => false
    t.text     "txt"
    t.integer  "student_id"
    t.integer  "question_id"
    t.boolean  "locked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
  end

  create_table "ckeditor_assets", :id => false, :force => true do |t|
    t.integer  "id",                                             :null => false
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

  create_table "contents", :id => false, :force => true do |t|
    t.integer  "id",           :null => false
    t.integer  "page_id"
    t.integer  "element_id"
    t.string   "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
    t.float    "weight"
  end

  create_table "courses", :id => false, :force => true do |t|
    t.integer  "id",                             :null => false
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

  create_table "courses_tutors", :id => false, :force => true do |t|
    t.integer "course_id", :null => false
    t.integer "tutor_id",  :null => false
  end

  add_index "courses_tutors", ["course_id", "tutor_id"], :name => "index_courses_tutors_on_course_id_and_tutor_id"
  add_index "courses_tutors", ["tutor_id", "course_id"], :name => "index_courses_tutors_on_tutor_id_and_course_id"

  create_table "deadlines", :force => true do |t|
    t.integer  "deadlinable_id"
    t.string   "deadlinable_type"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "developers", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers_stitch_modules", :id => false, :force => true do |t|
    t.integer "stitch_module_id"
    t.integer "developer_id"
  end

  create_table "discussion_links", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :id => false, :force => true do |t|
    t.integer  "id",                            :null => false
    t.integer  "student_id"
    t.integer  "group_id"
    t.boolean  "completed",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", :id => false, :force => true do |t|
    t.integer  "id",             :null => false
    t.integer  "value"
    t.integer  "gradable_id"
    t.string   "gradeable_type"
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_essays", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "max_length"
    t.text     "txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :id => false, :force => true do |t|
    t.integer  "id",                           :null => false
    t.string   "title"
    t.integer  "course_id"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "notes", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "text"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :id => false, :force => true do |t|
    t.integer  "id",                                :null => false
    t.string   "title"
    t.integer  "stitch_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
    t.boolean  "assignment",     :default => false
  end

  create_table "profile_sessions", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :id => false, :force => true do |t|
    t.integer  "id",                                 :null => false
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

  create_table "question_scores", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "question_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :id => false, :force => true do |t|
    t.integer  "id",                             :null => false
    t.text     "txt"
    t.boolean  "multi",        :default => true
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_length"
    t.text     "multianswers"
  end

  create_table "responses", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_texts", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slideshares", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "slide_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stitch_modules", :id => false, :force => true do |t|
    t.integer  "id",                             :null => false
    t.string   "title"
    t.text     "description"
    t.integer  "course_id"
    t.boolean  "complete",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_title"
    t.integer  "position"
  end

  create_table "stitch_units", :id => false, :force => true do |t|
    t.integer  "id",               :null => false
    t.integer  "stitch_module_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "deleted_at"
    t.float    "weight"
  end

  create_table "students", :id => false, :force => true do |t|
    t.integer  "id",                            :null => false
    t.boolean  "activated",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutors", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "youtubes", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.text     "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
