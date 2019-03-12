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

ActiveRecord::Schema.define(version: 2019_03_11_203918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bookmarks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "generic_uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minerva_assignments", force: :cascade do |t|
    t.string "title"
    t.boolean "automated"
    t.integer "interface_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interface_id"], name: "index_minerva_assignments_on_interface_id"
  end

  create_table "minerva_interfaces", force: :cascade do |t|
    t.string "title"
    t.string "code_point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minerva_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auid", null: false
    t.index ["auid"], name: "index_minerva_projects_on_auid", unique: true
  end

  create_table "minerva_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auid", null: false
    t.index ["auid"], name: "index_minerva_roles_on_auid", unique: true
  end

  create_table "minerva_states", force: :cascade do |t|
    t.integer "creator_id"
    t.integer "user_id"
    t.integer "role_id"
    t.integer "work_id"
    t.integer "minerva_assignment_id"
    t.integer "minerva_status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_minerva_states_on_creator_id"
    t.index ["minerva_assignment_id"], name: "index_minerva_states_on_minerva_assignment_id"
    t.index ["minerva_status_id"], name: "index_minerva_states_on_minerva_status_id"
    t.index ["role_id"], name: "index_minerva_states_on_role_id"
    t.index ["user_id"], name: "index_minerva_states_on_user_id"
    t.index ["work_id"], name: "index_minerva_states_on_work_id"
  end

  create_table "minerva_statuses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minerva_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auid", null: false
    t.index ["auid"], name: "index_minerva_users_on_auid", unique: true
  end

  create_table "minerva_workflows", force: :cascade do |t|
    t.integer "creator_id"
    t.integer "project_id"
    t.text "task_list"
    t.string "title"
    t.boolean "ordered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_minerva_workflows_on_creator_id"
    t.index ["project_id"], name: "index_minerva_workflows_on_project_id"
  end

  create_table "minerva_works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auid", null: false
    t.index ["auid"], name: "index_minerva_works_on_auid", unique: true
  end

  create_table "minter_states", id: :serial, force: :cascade do |t|
    t.string "namespace", default: "default", null: false
    t.string "template", null: false
    t.text "counters"
    t.bigint "seq", default: 0
    t.binary "rand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["namespace"], name: "index_minter_states_on_namespace", unique: true
  end

  create_table "orm_resources", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "internal_resource"
    t.integer "lock_version"
    t.index ["internal_resource"], name: "index_orm_resources_on_internal_resource"
    t.index ["metadata"], name: "index_orm_resources_on_metadata", using: :gin
    t.index ["metadata"], name: "index_orm_resources_on_metadata_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["updated_at"], name: "index_orm_resources_on_updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_registry_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
    t.index ["user_registry_id"], name: "index_roles_on_user_registry_id"
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "user_registries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "capacity"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "minerva_assignments", "minerva_interfaces", column: "interface_id"
  add_foreign_key "minerva_states", "minerva_assignments"
  add_foreign_key "minerva_states", "minerva_statuses"
end
