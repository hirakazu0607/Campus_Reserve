require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe "associations" do
    it { should have_many(:reservations).dependent(:destroy) }
  end

  describe "validations" do
    let(:facility) { build(:facility) }

    it "有効な属性の場合に有効であること" do
      expect(facility).to be_valid
    end

    describe "name" do
      it "存在しないと無効であること" do
        facility.name = nil
        expect(facility).not_to be_valid
        expect(facility.errors[:name]).to include("can't be blank")
      end

      it "100文字を超えると無効であること" do
        facility.name = "a" * 101
        expect(facility).not_to be_valid
      end

      it "重複していると無効であること" do
        create(:facility, name: "Gymnasium")
        facility.name = "Gymnasium"
        expect(facility).not_to be_valid
        expect(facility.errors[:name]).to include("has already been taken")
      end
    end

    describe "description" do
      it "任意であること" do
        facility.description = nil
        expect(facility).to be_valid
      end

      it "500文字以下であること" do
        facility.description = "a" * 501
        expect(facility).not_to be_valid
      end
    end

    describe "capacity" do
      it "存在しないと無効であること" do
        facility.capacity = nil
        expect(facility).not_to be_valid
      end

      it "整数であること" do
        facility.capacity = 10.5
        expect(facility).not_to be_valid
      end

      it "0より大きい必要があること" do
        facility.capacity = 0
        expect(facility).not_to be_valid

        facility.capacity = -1
        expect(facility).not_to be_valid
      end

      it "正の整数なら有効であること" do
        facility.capacity = 100
        expect(facility).to be_valid
      end
    end

    describe "location" do
      it "存在しないと無効であること" do
        facility.location = nil
        expect(facility).not_to be_valid
      end

      it "200文字以下であること" do
        facility.location = "a" * 201
        expect(facility).not_to be_valid
      end
    end
  end
end
