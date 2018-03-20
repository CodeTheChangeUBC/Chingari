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

ActiveRecord::Schema.define(version: 20180319020156) do

<<<<<<< HEAD
=======
  create_table "courses", force: :cascade do |t|
    t.string "title", default: "Untitled", null: false
    t.integer "users_id", null: false
    t.text "description", default: "No Description", null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier", default: 0, null: false
    t.index ["users_id"], name: "index_courses_on_users_id"
    t.index ["visibility"], name: "index_courses_on_visibility"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title", default: "Untitled", null: false
    t.integer "user_id", null: false
    t.string "attacheable_type", null: false
    t.integer "attacheable_id", null: false
    t.integer "display_index"
    t.index ["attacheable_type", "attacheable_id"], name: "index_documents_on_attacheable_type_and_attacheable_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
    t.index [nil, "attacheable_type"], name: "index_documents_on_attacheable_and_attacheable_type"
  end

  create_table "embeds", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "attacheable_type", null: false
    t.integer "attacheable_id", null: false
    t.text "content", default: "", null: false
    t.integer "display_index", default: 0, null: false
    t.index ["attacheable_type", "attacheable_id"], name: "index_embeds_on_attacheable_type_and_attacheable_id"
    t.index ["attacheable_type"], name: "index_embeds_on_attacheable_and_attacheable_type"
    t.index ["user_id"], name: "index_embeds_on_user_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "texts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "attacheable_type", null: false
    t.integer "attacheable_id", null: false
    t.text "content", default: "", null: false
    t.integer "display_index", default: 0, null: false
    t.index ["attacheable_type", "attacheable_id"], name: "index_texts_on_attacheable_type_and_attacheable_id"
    t.index ["attacheable_type"], name: "index_texts_on_attacheable_and_attacheable_type"
    t.index ["user_id"], name: "index_texts_on_user_id"
  end

>>>>>>> 3d6a30f5c2a36cb4e91fa516dae431dd93336f64
  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username", default: "Anonymous", null: false
    t.string "password_digest", null: false
    t.string "email"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

end
