require "test_helper"

describe Contact do
  describe "relations" do
    before do
      @contact = contacts(:one)
    end

    it "a contact belongs to from user" do
      @contact.must_respond_to :from_user
      @contact.from.must_be_kind_of Integer
    end

    # it "a contact belongs to to user" do
    #   @contact.must_respond_to :to_user
    #   @contact.to_user.must_be_kind_of User
    # end

  end

end
