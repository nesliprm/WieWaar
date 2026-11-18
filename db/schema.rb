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

ActiveRecord::Schema[8.1].define(version: 2026_11_18_123747) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cal_events", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "google_event_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.boolean "all_day", default: false, null: false
    t.string "status", null: false
    t.boolean "reachable", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "google_event_id"], name: "index_cal_events_on_employee_id_and_google_event_id", unique: true
    t.index ["employee_id"], name: "index_cal_events_on_employee_id"
    t.index ["ends_at"], name: "index_cal_events_on_ends_at"
    t.index ["starts_at"], name: "index_cal_events_on_starts_at"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname"
    t.string "email", null: false
    t.string "mobile"
    t.text "avatar_svg"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_employees_on_email", unique: true
  end

  create_table "ticketdiensts", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "employee_id"
    t.string "raw_name", null: false
    t.string "google_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "raw_name"], name: "index_ticketdiensts_on_date_and_raw_name", unique: true
    t.index ["employee_id"], name: "index_ticketdiensts_on_employee_id"
  end

  add_foreign_key "cal_events", "employees"
  add_foreign_key "ticketdiensts", "employees"
end
