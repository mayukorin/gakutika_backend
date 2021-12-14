# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_11_101945) do

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gakutikas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tough_rank"
    t.date "start_month"
    t.date "end_month"
    t.index ["user_id", "tough_rank"], name: "index_gakutikas_on_user_id_and_tough_rank", unique: true
    t.index ["user_id"], name: "index_gakutikas_on_user_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "query"
    t.date "day"
    t.string "answer"
    t.bigint "company_id"
    t.bigint "gakutika_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_questions_on_company_id"
    t.index ["gakutika_id"], name: "index_questions_on_gakutika_id"
  end

  create_table "user_and_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_user_and_companies_on_company_id"
    t.index ["user_id"], name: "index_user_and_companies_on_user_id"
  end

  create_table "user_and_company_and_gakutikas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "gakutika_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_and_company_id"
    t.index ["gakutika_id"], name: "index_user_and_company_and_gakutikas_on_gakutika_id"
    t.index ["user_and_company_id"], name: "index_user_and_company_and_gakutikas_on_user_and_company_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "gakutikas", "users"
  add_foreign_key "questions", "companies"
  add_foreign_key "questions", "gakutikas"
  add_foreign_key "user_and_companies", "companies"
  add_foreign_key "user_and_companies", "users"
  add_foreign_key "user_and_company_and_gakutikas", "gakutikas"
  add_foreign_key "user_and_company_and_gakutikas", "user_and_companies"
end
