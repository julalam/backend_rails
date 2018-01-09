require "test_helper"
# has_one :language
# has_one :from, :class_name => "User"
# has_one :to, :class_name => "User"

describe Message do
  # describe "relations" do
  #   before do
  #     @message = messages(:one)
  #   end
  #
  #   it "a message has one language" do
  #     @message.must_respond_to :language
  #   end
  #
  #   it "a message has many from messages" do
  #     @message.must_respond_to :from
  #     @message.from.each do |message|
  #       message.must_be_kind_of Message
  #     end
  #   end
  #
  #   it "a message has many to messages" do
  #     @message.must_respond_to :to
  #   end
  # end

  describe "validations" do
    # it "allows a message to be created with all required parameters" do
    #   start_count = Message.all.count
    #
    #   message_data = {
    #     text: "hello world",
    #     from: 1,
    #     to: 2,
    #     language: "ru"
    #   }
    #
    #   message = Message.new(message_data)
    #   message.save
    #   end_count = Message.all.count
    #
    #   message.must_be :valid?
    #   end_count.must_equal start_count + 1
    # end

    # it "requires all required data to create a new message" do
    #   start_count = Message.all.count
    #   invalid_message_data = {
    #     text: ""
    #   }
    #   message = Message.new(invalid_message_data)
    #   message.save
    #   end_count = Message.all.count
    #
    #   message.wont_be :valid?
    #   end_count.must_equal start_count
    # end
  end
end
