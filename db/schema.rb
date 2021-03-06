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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160210032308) do

  create_table "businesses", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "businesses", ["email"], name: "index_businesses_on_email", unique: true
  add_index "businesses", ["reset_password_token"], name: "index_businesses_on_reset_password_token", unique: true

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "email_domain"
    t.string   "category"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "expense_reports", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "status"
    t.integer  "manager_id"
  end

  add_index "expense_reports", ["user_id"], name: "index_expense_reports_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "manager_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "business_id"
  end

  add_index "groups", ["business_id"], name: "index_groups_on_business_id"

  create_table "receipts", force: :cascade do |t|
    t.string   "receipt_desc"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "company_id"
    t.integer  "user_id"
    t.date     "plain_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "company_name"
    t.integer  "expense_report_id"
    t.string   "in_reply_to"
    t.float    "price"
  end

  add_index "receipts", ["company_id"], name: "index_receipts_on_company_id"
  add_index "receipts", ["expense_report_id"], name: "index_receipts_on_expense_report_id"
  add_index "receipts", ["user_id"], name: "index_receipts_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["business_id"], name: "index_relationships_on_business_id"
  add_index "relationships", ["user_id"], name: "index_relationships_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "users_groups", ["group_id"], name: "index_users_groups_on_group_id"
  add_index "users_groups", ["user_id"], name: "index_users_groups_on_user_id"

  create_table "users_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
