ActiveRecord::Schema.define(version: 2021_08_24_011022) do

  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["completed"], name: "index_todos_on_completed"
  end

end
