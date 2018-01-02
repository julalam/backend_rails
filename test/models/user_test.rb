require "test_helper"

describe User do
  describe "validations" do
    it "allows a user to be created with all required data" do
      start_count = User.all.count

      user_data = {
        username: "New User",
        language: "ru"
      }

      user = User.new(user_data)
      user.save
      end_count = User.all.count

      user.must_be :valid?
      end_count.must_equal start_count + 1
    end

    it "requires all required data to create a new user" do
      start_count = User.all.count
      invalid_user_data = {
        username: ""
      }
      user = User.new(invalid_user_data)
      user.save
      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires unique username to create a new user" do
      start_count = User.all.count

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

    end_count = User.all.count

    end_count.must_equal start_count + 2
    end
  end
end
