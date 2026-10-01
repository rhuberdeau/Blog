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

ActiveRecord::Schema[8.1].define(version: 2026_10_01_160000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "published", default: false
    t.integer "user_id"
    t.text "summary"
    t.datetime "published_on"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "phone_number"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_taggings_on_article_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
