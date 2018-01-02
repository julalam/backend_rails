require "test_helper"

describe User do
  describe "validations" do
    it "allows a user to be created with all required data" do
      user_data = {
        username: "New User",
        language: "ru" }

      user = User.new(user_data)

      user.must_be :valid?
    end

    it "requires all the data to create a new user" do
      invalid_user_data = {
        username: ""
      }
      user = User.new(invalid_user_data)

      user.wont_be :valid?
    end

    it "requires unique username to create a new user" do
      start_user_count = User.all.length

      user_data = {
        username: "New User",
        language: "ru" }
      user = User.new(user_data)
      user.save

      invalid_user_data = {
        username: "New User",
        language: "en"
      }
      same_user = User.new(invalid_user_data)
      same_user.save

      valid_user_data = {
        username: "Another User",
        language: "en"
      }
      new_user = User.new(valid_user_data)
      new_user.save

    end_user_count = User.all.length

    end_user_count.must_equal start_user_count + 2
    end
  end
end
