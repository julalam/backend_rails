require "test_helper"

describe Language do
  describe "relations" do
    before do
      @language = languages(:language_one)
    end

    it "a languages has many users" do
      @language.must_respond_to :users
      @language.users.each do |user|
        user.must_be_kind_of User
      end
    end

    it "a languages has many messages" do
      @language.must_respond_to :messages
      @language.messages.each do |message|
        message.must_be_kind_of Message
      end
    end
  end

  describe "validations" do
    it "a language can be created with all required fields" do
      start_count = Language.all.count

      language_data = {
        name: "Korean",
        native_name: "Korean",
        code: "ko"
      }

      language = Language.new(language_data)
      language.save
      end_count = Language.all.count

      language.must_be :valid?
      end_count.must_equal start_count + 1
    end

    it "requires all required fields to create new language" do
      start_count = Language.all.count

      language_data = {
        name: "New language",
        code: "nl"
      }

      language = Language.new(language_data)
      language.save
      end_count = Language.all.count

      language.wont_be :valid?
      end_count.must_equal start_count
    end

    it "requires unique name, natuve_name and code to create a new language" do
      start_count = Language.all.count
      language_data = {
        name: "Russian",
        native_name: "Russian",
        code: "ru"
      }
      language = Language.new(language_data)
      language.save
      end_count = Language.all.count

      language.wont_be :valid?
      end_count.must_equal start_count
    end
  end
end
