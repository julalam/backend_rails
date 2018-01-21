require "test_helper"

describe User do
  describe "relations" do
    before do
      @user = users(:eva)
    end

    it "a user has many from_contacts" do
      @user.must_respond_to :from_contacts
      @user.from_contacts.each do |contact|
        contact.must_be_kind_of Contact
      end
    end

    it "a user has many to_contacts" do
      @user.must_respond_to :to_contacts
      @user.to_contacts.each do |contact|
        contact.must_be_kind_of Contact
      end
    end

    it "a user has many from_messages" do
      @user.must_respond_to :from_messages
      @user.from_messages.each do |message|
        message.must_be_kind_of Message
      end
    end

    it "a user has many to_messages" do
      @user.must_respond_to :to_messages
      @user.to_messages.each do |message|
        message.must_be_kind_of Message
      end
    end

    it "a user has avatar" do
      @user.must_respond_to :avatar
    end

  end

  describe "validations" do
    it "allows a user to be created with all required data" do
      start_count = User.all.count

      user_data = {
        username: "New User",
        language: "ru",
        country: "Russia",
        password: "jhfgdtr",
        email: "user@mail.ru"
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
        username: "User"
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
        username: "Eva",
        email: "eva@gmail.com",
        password: "hellohello",
        language: "en",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires username between 3-15 characters to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "Ev",
        email: "eva@gmail.com",
        password: "hellohello",
        language: "en",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires language to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "User",
        email: "eva@gmail.com",
        password: "hellohello",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "not requires country to create a new user" do
      start_count = User.all.count
      user_data = {
        username: "New User",
        language: "ru",
        password: "jhfgdtr",
        email: "user@mail.ru"
      }
      user = User.new(user_data)
      user.save
      end_count = User.all.count

      user.must_be :valid?
      end_count.must_equal start_count + 1
    end

    it "requires email to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "User",
        language: "en",
        password: "hellohello",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires email in a right format to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "User",
        email: "my email",
        language: "en",
        password: "hellohello",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires password to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "User",
        email: "email@mail.com",
        language: "en",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires password to be 6-10 characters long to create a new user" do
      start_count = User.all.count

      user_data = {
        username: "User",
        email: "email@mail.com",
        password: "hi",
        language: "en",
        country: "USA" }
      user = User.new(user_data)
      user.save

      end_count = User.all.count

      user.wont_be :valid?
      end_count.must_equal start_count
    end
  end
end
