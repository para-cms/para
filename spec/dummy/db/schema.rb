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

ActiveRecord::Schema.define(version: 20161105115652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "para_cache_items", force: :cascade do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "para_component_resources", force: :cascade do |t|
    t.integer  "component_id"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["component_id"], name: "index_para_component_resources_on_component_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_para_component_resources_on_resource_type_and_resource_id", using: :btree
  end

  create_table "para_component_sections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier"
    t.integer  "position"
  end

  create_table "para_components", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.hstore   "configuration",        default: {}, null: false
    t.integer  "position",             default: 0
    t.integer  "component_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "identifier"
    t.index ["slug"], name: "index_para_components_on_slug", using: :btree
  end

  create_table "para_library_files", force: :cascade do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "para_page_sections", force: :cascade do |t|
    t.string   "type"
    t.jsonb    "data"
    t.integer  "position",   default: 0
    t.string   "page_type"
    t.integer  "page_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["page_type", "page_id"], name: "index_para_page_sections_on_page_type_and_page_id", using: :btree
  end

  add_foreign_key "para_component_resources", "para_components", column: "component_id"
end
