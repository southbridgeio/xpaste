require "./spec_helper"
require "../../src/models/paste.cr"

describe Paste do
  Spec.before_each do
    Paste.clear
  end

  describe ".generate_token" do
    it "generates token with correct chars number" do
      token = Paste.generate_token(5)

      token.size.should eq 5
    end
  end

  describe "#auto_destroy?" do
    it "returns field value" do
      paste = Paste.new(auto_destroy: false)
      paste.auto_destroy?.should eq false

      paste.auto_destroy = true
      paste.auto_destroy?.should eq true
    end
  end

  describe "#ttl_days" do
    it "returns calculated ttl" do
      Timecop.travel(Time.local(2020, 1, 1, 0, 0, 0)) do
        paste = Paste.new(will_be_deleted_at: Time.local(2020, 1, 6, 0, 0, 0))
        paste.ttl_days.should eq 5
      end
    end
  end

  describe "#ttl_days=" do
    context "when days is lower than 5000" do
      it "assigns days value will_be_deleted_at" do
        Timecop.travel(Time.local(2020, 1, 1, 0, 0, 0)) do
          paste = Paste.new
          paste.ttl_days = 5
          paste.will_be_deleted_at.as(Time).date.should eq Time.local(2020, 1, 6, 0, 0, 0).date
        end
      end
    end

    context "when days is greater than 5000" do
      it "assigns current date + 5000 days to will_be_deleted_at" do
        paste = Paste.new
        paste.ttl_days = 6000

        paste.will_be_deleted_at.as(Time).date.should eq 5000.days.from_now.date
      end
    end
  end
end
