require "rails_helper"

RSpec.describe Station, type: :model do
  fixtures :stations

  subject(:station) do
    described_class.new(
      name: "Test Station",
      load_seconds: 0
    )
  end

  describe ".order(:id)" do
    it "returns the seeded stations in the expected order" do
      expect(Station.order(:id).pluck(:id, :name, :load_seconds)).to eq(
        [
          [1, "Station 1", 0],
          [2, "Station 2", 0]
        ]
      )
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:load_seconds) }
    it { is_expected.to validate_numericality_of(:load_seconds).is_greater_than_or_equal_to(0) }
  end
end
