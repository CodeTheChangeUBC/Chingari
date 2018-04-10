require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase

  def setup 
  end

  test "No dangling enrollments" do
    assert_raises(Exception) { Enrollment.create!() }
    assert_raises(Exception) { Enrollment.create!(user_id: 1) }
    assert_raises(Exception) { Enrollment.create!(course_id: 1) }
  end

  test "Should create enrollment when foreign ID's are present" do
    assert Enrollment.create!(course_id: 100, user_id: 1)
  end
end
