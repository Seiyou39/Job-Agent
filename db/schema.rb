# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_20_042035) do
  create_table "analyses", force: :cascade do |t|
    t.text "advice"
    t.string "company_name"
    t.datetime "created_at", null: false
    t.text "interview_questions"
    t.text "jd_text"
    t.string "job_title"
    t.string "location"
    t.integer "match_score"
    t.text "skill_gaps"
    t.text "strengths"
    t.integer "todo_list_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["todo_list_id"], name: "index_analyses_on_todo_list_id"
    t.index ["user_id"], name: "index_analyses_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "todo_lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "source"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_todo_lists_on_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "done"
    t.string "priority"
    t.string "task"
    t.integer "todo_list_id", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_list_id"], name: "index_todos_on_todo_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.text "resume_text"
    t.string "role", default: "reviewer", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "analyses", "todo_lists"
  add_foreign_key "analyses", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "todo_lists", "users"
  add_foreign_key "todos", "todo_lists"
end
