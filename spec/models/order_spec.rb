require "rails_helper"

RSpec.describe Order, type: :model do
  fixtures :menu_items

  subject(:order) do
    described_class.new(
      subtotal_cents: 1_298,
      discount_cents: 100,
      total_cents: 1_198
    )
  end

  describe "associations" do
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to have_many(:station_queues).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:order_items) }
    it { is_expected.to validate_presence_of(:subtotal_cents) }
    it { is_expected.to validate_numericality_of(:subtotal_cents).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:discount_cents) }
    it { is_expected.to validate_numericality_of(:discount_cents).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:total_cents) }
    it { is_expected.to validate_numericality_of(:total_cents).is_greater_than(0) }
  end
end
