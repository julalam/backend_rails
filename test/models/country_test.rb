require "test_helper"

describe Country do
  describe "validations" do
    before do
      @country = countries(:usa)
    end

    it "requires name to create a new country" do
      start_count = Country.all.count
      country = Country.new(name: "Russia")
      country.save
      end_count = Country.all.count

      country.must_be :valid?
      end_count.must_equal start_count + 1
    end

    it "requires unique name to create a new country" do
      start_count = Country.all.count
      country = Country.new(name: "USA")
      country.save
      end_count = Country.all.count

      country.wont_be :valid?
      end_count.must_equal start_count
    end
  end
end
