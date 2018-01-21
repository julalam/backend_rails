require "test_helper"

describe Contact do
  describe "relations" do
    before do
      @contact = contacts(:one)
    end

    it "a contact belongs to from_user" do
      @contact.must_respond_to :from_user
      @contact.from_user.must_be_kind_of User
    end

    it "a contact belongs to to_user" do
      @contact.must_respond_to :to_user
      @contact.to_user.must_be_kind_of User
    end
  end

  describe "validations" do
    it "allows to create a new contact with all required data" do
      start_count = Contact.all.count
      contact = Contact.new(from: 1, to: 2)
      contact.save
      end_count = Contact.all.count
      contact.must_be :valid?
      end_count.must_equal start_count + 1
    end

    it "requires all required data to create a new contact" do
      start_count = Contact.all.count
      contact = Contact.new(to: 2)
      contact.save
      end_count = Contact.all.count
      contact.wont_be :valid?
      end_count.must_equal start_count
    end
  end
end
