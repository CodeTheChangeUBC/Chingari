  # create_table "enrollments", force: :cascade do |t|
  #   t.integer "course_id", null: false
  #   t.integer "user_id", null: false
  #   t.datetime "created_at", null: false
  #   t.datetime "updated_at", null: false
  #   t.index ["course_id"], name: "index_enrollments_on_course_id"
  #   t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
  #   t.index ["user_id"], name: "index_enrollments_on_user_id"
  # end
  
class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user
end
