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

ActiveRecord::Schema.define(version: 20160307215258) do

  create_table "datasets", force: :cascade do |t|
    t.string   "dataset_name"
    t.text     "description"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "zipfile_file_name"
    t.string   "zipfile_content_type"
    t.integer  "zipfile_file_size"
    t.datetime "zipfile_updated_at"
  end

  create_table "records", force: :cascade do |t|
    t.text     "data"
    t.integer  "dataset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "records", ["dataset_id"], name: "index_records_on_dataset_id"

end
