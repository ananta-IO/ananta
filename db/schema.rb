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

ActiveRecord::Schema.define(:version => 20120930010501) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "question_relevance"
    t.string   "state"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["question_relevance"], :name => "index_answers_on_question_relevance"
  add_index "answers", ["state"], :name => "index_answers_on_state"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "comment"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "images", :force => true do |t|
    t.integer  "user_id"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "image"
    t.string   "image_type",     :default => "picture"
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "images", ["image_type"], :name => "index_images_on_image_type"
  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"
  add_index "images", ["lat", "lng"], :name => "index_images_on_lat_and_lng"
  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "locations", :force => true do |t|
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.string   "name",                        :default => "default"
    t.string   "address"
    t.string   "timezone"
    t.float    "lat"
    t.float    "lng"
    t.text     "data"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "postal_code"
    t.string   "country"
    t.string   "administrative_area_level_1"
    t.string   "administrative_area_level_2"
  end

  add_index "locations", ["address"], :name => "index_locations_on_address"
  add_index "locations", ["administrative_area_level_1"], :name => "index_locations_on_administrative_area_level_1"
  add_index "locations", ["administrative_area_level_2"], :name => "index_locations_on_administrative_area_level_2"
  add_index "locations", ["country"], :name => "index_locations_on_country"
  add_index "locations", ["lat", "lng"], :name => "index_locations_on_lat_and_lng"
  add_index "locations", ["locatable_id", "locatable_type"], :name => "index_locations_on_locatable_id_and_locatable_type"
  add_index "locations", ["postal_code"], :name => "index_locations_on_postal_code"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "view_count",    :default => 0
    t.string   "gender"
    t.datetime "date_of_birth"
  end

  add_index "profiles", ["date_of_birth"], :name => "index_profiles_on_date_of_birth"
  add_index "profiles", ["gender"], :name => "index_profiles_on_gender"
  add_index "profiles", ["name"], :name => "index_profiles_on_name"
  add_index "profiles", ["slug"], :name => "index_profiles_on_slug", :unique => true

  create_table "project_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "permissions", :default => 2
    t.string   "state"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "project_memberships", ["project_id"], :name => "index_project_memberships_on_project_id"
  add_index "project_memberships", ["user_id"], :name => "index_project_memberships_on_user_id"

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "state"
    t.string   "slug"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "timezone"
    t.float    "lat"
    t.float    "lng"
    t.integer  "view_count",  :default => 0
  end

  add_index "projects", ["lat", "lng"], :name => "index_projects_on_lat_and_lng"
  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true
  add_index "projects", ["state"], :name => "index_projects_on_state"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "questionable_id"
    t.string   "questionable_type"
    t.string   "questionable_sid"
    t.string   "questionable_controller"
    t.text     "questionable_url"
    t.string   "questionable_action"
    t.string   "question"
    t.string   "state"
    t.integer  "answer_count",            :default => 0
    t.integer  "yes_count",               :default => 0
    t.integer  "no_count",                :default => 0
    t.integer  "dont_care_count",         :default => 0
    t.integer  "avg_relevance",           :default => 0
    t.integer  "score",                   :default => 1000
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "view_count",              :default => 0
  end

  add_index "questions", ["answer_count"], :name => "index_questions_on_answer_count"
  add_index "questions", ["avg_relevance"], :name => "index_questions_on_avg_relevance"
  add_index "questions", ["dont_care_count"], :name => "index_questions_on_dont_care_count"
  add_index "questions", ["no_count"], :name => "index_questions_on_no_count"
  add_index "questions", ["questionable_action"], :name => "index_questions_on_questionable_action"
  add_index "questions", ["questionable_controller"], :name => "index_questions_on_questionable_controller"
  add_index "questions", ["questionable_id", "questionable_type"], :name => "index_questions_on_questionable_id_and_questionable_type"
  add_index "questions", ["questionable_sid"], :name => "index_questions_on_questionable_sid"
  add_index "questions", ["questionable_url"], :name => "index_questions_on_questionable_url"
  add_index "questions", ["score"], :name => "index_questions_on_score"
  add_index "questions", ["state"], :name => "index_questions_on_state"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"
  add_index "questions", ["yes_count"], :name => "index_questions_on_yes_count"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "permissions",            :default => 0
    t.string   "facebook_id"
    t.string   "username"
    t.string   "slug"
    t.string   "timezone"
    t.float    "lat"
    t.float    "lng"
    t.integer  "projects_count",         :default => 0
    t.integer  "joined_projects_count",  :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["joined_projects_count"], :name => "index_users_on_joined_projects_count"
  add_index "users", ["lat", "lng"], :name => "index_users_on_lat_and_lng"
  add_index "users", ["permissions"], :name => "index_users_on_permissions"
  add_index "users", ["projects_count"], :name => "index_users_on_projects_count"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "views", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "user_id"
    t.string   "ip"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "views", ["ip"], :name => "index_views_on_ip"
  add_index "views", ["user_id"], :name => "index_views_on_user_id"
  add_index "views", ["viewable_id", "viewable_type"], :name => "index_views_on_viewable_id_and_viewable_type"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
