require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User", number: "0001")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 21
    assert_not @user.valid?
  end

  test "number should be 4 digits" do
    @user.number = "0" * 4
    assert @user.valid?
  end

  test "number validation should reject invalid format" do
    invalid_strings = %w[001 00001 a001 abcd a0001 0001a ０００１]
    invalid_strings.each do |string|
      @user.number = string
      assert_not @user.valid?, "#{string.inspect} should be invalid"
    end
  end

  test "number should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

end
