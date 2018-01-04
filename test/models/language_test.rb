require "test_helper"

describe Language do
  let(:language) { Language.new }

  it "must be valid" do
    value(language).must_be :valid?
  end
end
