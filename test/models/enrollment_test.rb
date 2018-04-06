require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  test "No dangling enrollments" do
    assert_raises(Exception) { Enrollment.create!() }
    assert_raises(Exception) { Enrollment.create!(user_id: 1) }
    assert_raises(Exception) { Enrollment.create!(course_id: 1) }
  end
end
