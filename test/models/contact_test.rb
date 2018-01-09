require "test_helper"

describe Contact do
  describe "relations" do
    before do
      @contact = contacts(:one)
    end

    it "a contact belongs to from user" do
      @contact.must_respond_to :from
      @contact.from.must_be_kind_of User
    end

    it "a contact belongs to to user" do
      @contact.must_respond_to :to
      @contact.to.must_be_kind_of User
    end

  end

end
