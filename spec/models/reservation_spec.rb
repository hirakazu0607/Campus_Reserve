require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:facility) }
  end

  describe "validations" do
    let(:reservation) { build(:reservation) }

    it "is valid with valid attributes" do
      expect(reservation).to be_valid
    end

    describe "start_time" do
      it "is invalid without a start_time" do
        reservation.start_time = nil
        expect(reservation).not_to be_valid
        expect(reservation.errors[:start_time]).to include("can't be blank")
      end

      it "is invalid if in the past" do
        reservation.start_time = 1.hour.ago
        expect(reservation).not_to be_valid
        expect(reservation.errors[:start_time]).to include("未来の日時を指定してください")
      end
    end

    describe "end_time" do
      it "is invalid without an end_time" do
        reservation.end_time = nil
        expect(reservation).not_to be_valid
        expect(reservation.errors[:end_time]).to include("can't be blank")
      end

      it "is invalid if before start_time" do
        reservation.start_time = 2.days.from_now.change(hour: 14, min: 0)
        reservation.end_time = 2.days.from_now.change(hour: 12, min: 0)
        expect(reservation).not_to be_valid
        expect(reservation.errors[:end_time]).to include("開始時刻より後に設定してください")
      end

      it "is invalid if equal to start_time" do
        time = 2.days.from_now.change(hour: 14, min: 0)
        reservation.start_time = time
        reservation.end_time = time
        expect(reservation).not_to be_valid
        expect(reservation.errors[:end_time]).to include("開始時刻より後に設定してください")
      end
    end

    describe "purpose" do
      it "is optional" do
        reservation.purpose = nil
        expect(reservation).to be_valid
      end

      it "is invalid with more than 500 characters" do
        reservation.purpose = "a" * 501
        expect(reservation).not_to be_valid
      end

      it "is valid with 500 characters" do
        reservation.purpose = "a" * 500
        expect(reservation).to be_valid
      end
    end

    describe "status" do
      it "is invalid without a status" do
        reservation.status = nil
        expect(reservation).not_to be_valid
      end

      it "defaults to pending" do
        new_reservation = Reservation.new
        expect(new_reservation.status).to eq("pending")
      end
    end

    describe "time overlap validation" do
      let(:facility) { create(:facility) }
      let(:user) { create(:user) }

      it "is invalid if time overlaps with existing reservation" do
        # Create an existing reservation
        create(:reservation,
               facility: facility,
               user: user,
               start_time: 2.days.from_now.change(hour: 10, min: 0),
               end_time: 2.days.from_now.change(hour: 12, min: 0))

        # Try to create overlapping reservation
        overlapping = build(:reservation,
                            facility: facility,
                            user: user,
                            start_time: 2.days.from_now.change(hour: 11, min: 0),
                            end_time: 2.days.from_now.change(hour: 13, min: 0))

        expect(overlapping).not_to be_valid
        expect(overlapping.errors[:base]).to include("この時間帯はすでに予約されています")
      end

      it "is valid if reservation is for a different facility" do
        other_facility = create(:facility, name: "Other Room")

        create(:reservation,
               facility: facility,
               start_time: 2.days.from_now.change(hour: 10, min: 0),
               end_time: 2.days.from_now.change(hour: 12, min: 0))

        non_overlapping = build(:reservation,
                                facility: other_facility,
                                start_time: 2.days.from_now.change(hour: 11, min: 0),
                                end_time: 2.days.from_now.change(hour: 13, min: 0))

        expect(non_overlapping).to be_valid
      end

      it "is valid if times don't overlap" do
        create(:reservation,
               facility: facility,
               start_time: 2.days.from_now.change(hour: 10, min: 0),
               end_time: 2.days.from_now.change(hour: 12, min: 0))

        non_overlapping = build(:reservation,
                                facility: facility,
                                start_time: 2.days.from_now.change(hour: 13, min: 0),
                                end_time: 2.days.from_now.change(hour: 15, min: 0))

        expect(non_overlapping).to be_valid
      end

      it "ignores cancelled reservations when checking overlap" do
        create(:reservation, :cancelled,
               facility: facility,
               start_time: 2.days.from_now.change(hour: 10, min: 0),
               end_time: 2.days.from_now.change(hour: 12, min: 0))

        new_reservation = build(:reservation,
                                facility: facility,
                                start_time: 2.days.from_now.change(hour: 11, min: 0),
                                end_time: 2.days.from_now.change(hour: 13, min: 0))

        expect(new_reservation).to be_valid
      end
    end
  end

  describe "enum status" do
    let(:reservation) { create(:reservation) }

    it "can be pending" do
      reservation.pending!
      expect(reservation.pending?).to be true
    end

    it "can be approved" do
      reservation.approved!
      expect(reservation.approved?).to be true
    end

    it "can be rejected" do
      reservation.rejected!
      expect(reservation.rejected?).to be true
    end

    it "can be cancelled" do
      reservation.cancelled!
      expect(reservation.cancelled?).to be true
    end
  end
end
