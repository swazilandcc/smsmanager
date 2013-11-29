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

ActiveRecord::Schema.define(:version => 20131129185503) do

  create_table "bulk_message_templates", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "competition_options", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "option_number"
    t.string   "option_name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "keyword"
    t.boolean  "keyword_case_sensitive"
    t.integer  "user_id"
    t.text     "success_message"
    t.text     "closed_message"
    t.boolean  "active"
    t.string   "incorrect_option_message"
    t.boolean  "response_include_serial"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cell_number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "region_id"
    t.string   "church"
  end

  add_index "contacts", ["cell_number"], :name => "index_contacts_on_cell_number"
  add_index "contacts", ["first_name"], :name => "index_contacts_on_first_name"

  create_table "contacts_groups", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "incoming_messages", :force => true do |t|
    t.string   "sender"
    t.string   "keyword"
    t.string   "option"
    t.string   "extra_text"
    t.boolean  "reply_sent"
    t.datetime "reply_sent_date_time"
    t.string   "reply_message"
    t.boolean  "matched_to_competition"
    t.boolean  "matched_to_devotional"
    t.integer  "devotional_id"
    t.integer  "competition_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "matched_to_quiz"
  end

  create_table "quiz_entries", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "cell_number"
    t.boolean  "completed"
    t.integer  "current_question"
    t.integer  "incoming_message_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "quiz_entry_answers", :force => true do |t|
    t.integer  "quiz_entry_id"
    t.integer  "quiz_question_id"
    t.integer  "quiz_question_answer_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "quiz_question_answers", :force => true do |t|
    t.integer  "quiz_question_id"
    t.string   "letter"
    t.text     "answer"
    t.boolean  "correct_answer"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "score"
  end

  add_index "quiz_question_answers", ["quiz_question_id"], :name => "index_quiz_question_answers_on_quiz_question_id"

  create_table "quiz_questions", :force => true do |t|
    t.integer  "quiz_id"
    t.text     "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "quiz_questions", ["quiz_id"], :name => "index_quiz_questions_on_quiz_id"

  create_table "quizzes", :force => true do |t|
    t.string   "keyword"
    t.text     "welcome_message"
    t.text     "correct_answer"
    t.text     "incorrect_answer"
    t.boolean  "enabled"
    t.boolean  "next_on_incorrect"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "total_score"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "regions", ["id"], :name => "index_regions_on_id"

  create_table "send_bulk_messages", :force => true do |t|
    t.integer  "group_id"
    t.text     "message"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sms_logs", :force => true do |t|
    t.string   "cell_number"
    t.string   "message"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",             :default => "", :null => false
    t.string   "last_name",              :default => "", :null => false
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
    t.integer  "role_mask"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
