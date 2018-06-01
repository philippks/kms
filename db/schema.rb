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

ActiveRecord::Schema.define(version: 20180223204928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.date "from_date"
    t.date "to_date"
    t.decimal "hours"
    t.integer "reason"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_absences_on_employee_id"
  end

  create_table "activity_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "not_chargeable", default: false
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_group_id"
    t.string "confidential_title"
    t.string "email_address"
    t.integer "invoice_delivery"
    t.boolean "deactivated", default: false
    t.string "invoice_hint"
    t.index ["customer_group_id"], name: "index_customers_on_customer_group_id"
  end

  create_table "efforts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "employee_id"
    t.integer "customer_id"
    t.date "date"
    t.string "text"
    t.string "note"
    t.string "state", default: "0"
    t.decimal "hours"
    t.integer "hourly_rate_cents"
    t.integer "activity_category_id"
    t.integer "amount_cents"
    t.integer "invoice_effort_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["activity_category_id"], name: "index_efforts_on_activity_category_id"
    t.index ["customer_id"], name: "index_efforts_on_customer_id"
    t.index ["employee_id"], name: "index_efforts_on_employee_id"
    t.index ["invoice_effort_id"], name: "index_efforts_on_invoice_effort_id"
  end

  create_table "employees", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "initials"
    t.integer "hourly_rate_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "worktime_model"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.boolean "deactivated", default: false
    t.index ["email"], name: "index_employees_on_email", unique: true
  end

  create_table "hourly_rates", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "customer_id"
    t.integer "hourly_rate_cents"
    t.index ["customer_id"], name: "index_hourly_rates_on_customer_id"
    t.index ["employee_id"], name: "index_hourly_rates_on_employee_id"
  end

  create_table "invoice_efforts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "text"
    t.integer "invoice_id"
    t.decimal "hours_manually"
    t.integer "hourly_rate_manually_cents"
    t.integer "efforts_count", default: 0
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "confidential", default: false
    t.boolean "visible", default: true
    t.boolean "pagebreak", default: false
    t.integer "amount_manually_cents"
    t.index ["invoice_id"], name: "index_invoice_efforts_on_invoice_id"
  end

  create_table "invoice_mails", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.string "body"
    t.bigint "invoice_id"
    t.bigint "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["employee_id"], name: "index_invoice_mails_on_employee_id"
    t.index ["invoice_id"], name: "index_invoice_mails_on_invoice_id"
  end

  create_table "invoice_payments", id: :serial, force: :cascade do |t|
    t.date "date", null: false
    t.integer "amount_cents", null: false
    t.integer "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_payments_on_invoice_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.date "date", default: "2015-12-30"
    t.decimal "vat_rate", null: false
    t.integer "employee_id"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confidential", default: false
    t.boolean "display_swift", default: false
    t.integer "activities_amount_manually_cents"
    t.integer "possible_wir_amount_cents", default: 0
    t.string "title"
    t.integer "format", default: 0
    t.string "state"
    t.integer "persisted_total_amount_cents"
    t.integer "delivery_method"
    t.string "created_by_initials"
    t.datetime "sent_at"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["employee_id"], name: "index_invoices_on_employee_id"
  end

  create_table "target_hours", id: :serial, force: :cascade do |t|
    t.date "date"
    t.integer "hours", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_templates", id: :serial, force: :cascade do |t|
    t.string "text"
    t.integer "activity_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_category_id"], name: "index_text_templates_on_activity_category_id"
  end

  add_foreign_key "absences", "employees"
  add_foreign_key "efforts", "activity_categories"
  add_foreign_key "efforts", "customers"
  add_foreign_key "efforts", "employees"
  add_foreign_key "invoice_efforts", "invoices"
  add_foreign_key "invoice_mails", "employees"
  add_foreign_key "invoice_mails", "invoices"
  add_foreign_key "invoice_payments", "invoices"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "employees"
  add_foreign_key "text_templates", "activity_categories"
end
