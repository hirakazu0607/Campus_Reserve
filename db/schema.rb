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

ActiveRecord::Schema[8.1].define(version: 2025_12_15_120151) do
  create_table "facilities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_facilities_on_name", unique: true
  end

  create_table "reservations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time", null: false
    t.bigint "facility_id", null: false
    t.text "purpose"
    t.datetime "start_time", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["facility_id", "start_time", "end_time"], name: "index_reservations_on_facility_id_and_start_time_and_end_time"
    t.index ["facility_id"], name: "index_reservations_on_facility_id"
    t.index ["status"], name: "index_reservations_on_status"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", default: "", null: false
    t.string "password_digest", null: false
    t.integer "role", null: false
    t.integer "student_or_staff_number", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["student_or_staff_number"], name: "index_users_on_student_or_staff_number", unique: true
  end

  add_foreign_key "reservations", "facilities"
  add_foreign_key "reservations", "users"
end
