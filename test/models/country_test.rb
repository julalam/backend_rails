require "test_helper"

describe Country do
  let(:country) { Country.new }

  it "must be valid" do
    value(country).must_be :valid?
  end
end
