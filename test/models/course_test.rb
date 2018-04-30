require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  
  def setup
    @course = Course.new(title: "Test Course", user_id: 1, description: "Test Description is this one", visibility: 0, tier: 0)
  end

  test "should be valid" do 
    assert @course.valid?
  end

  test "title should be present" do 
    @course.title = ""
    assert_not @course.valid?
  end

  test "user_id should be present" do 
    @course.user_id = ""
    assert_not @course.valid?
  end

  test "description should be present" do 
    @course.description = ""
    assert_not @course.valid?
  end

  test "title should have minimum length 1" do 
    @course.title = ""
    assert_not @course.valid?
  end

  test "title should have maximum length 140" do 
    @course.title = "a" * 256
    assert_not @course.valid?
  end

  test "title should not be all whitespace" do
    @course.title = (" " * 5) + ("\t" * 5)
    assert_not @course.valid?
  end

  test "description should have minimum length 1" do 
    @course.description = ""
    assert_not @course.valid?
  end

  test "description should have maximum length 1000" do 
    @course.description = "a" * 20048
    assert_not @course.valid?
  end

  test "description should not be all whitespace" do
    @course.description = (" " * 5) + ("\t" * 5)
    assert_not @course.valid?
  end

  test "visibility should be a number" do
    @course.visibility = "test"
    assert_not @course.valid?
  end

  test "visibility should be within enum" do
    @course.visibility = 10
    assert_not @course.valid?
  end

  test "tier should be a number" do
    @course.tier = "test"
    assert_not @course.valid?
  end

  test "tier should be within enum" do
    @course.tier = 10
    assert_not @course.valid?
  end

end