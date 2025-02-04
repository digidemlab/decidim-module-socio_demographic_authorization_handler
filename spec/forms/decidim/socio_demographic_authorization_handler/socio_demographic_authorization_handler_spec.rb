# frozen_string_literal: true

require "spec_helper"

describe SocioDemographicAuthorizationHandler do
  subject do
    described_class.new(
      user:,
      gender:,
      age:,
      phone_number:,
      living_area:,
      participation_process:
    )
  end

  let!(:participatory_spaces) { create_list(:participatory_process, 3, organization:) }
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization:) }
  let(:gender) { "man" }
  let(:age) { "16-20" }
  let(:phone_number) { "+46701234567" }
  let(:living_area) { "Bosatt i kranskommun till Göteborg" }
  let(:participation_process) { "participatory_process_id_#{participatory_spaces.first.id}" }

  context "when all information is valid" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when gender is not in list" do
    let(:gender) { "invalid_gender" }

    it "is not valid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:gender]).to include("is not included in the list")
    end
  end

  context "when gender field is blank" do
    let(:gender) { "" }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when age is not in list" do
    let(:age) { "invalid_age" }

    it "is not valid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:age]).to include("is not included in the list")
    end
  end

  context "when age field is blank" do
    let(:age) { "" }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when phone_number has invalid format" do
    let(:phone_number) { "invalid_phone_number" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when phone_number field is blank" do
    let(:phone_number) { "" }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when living_area is not in list" do
    let(:living_area) { "invalid_area" }

    it "is not valid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:living_area]).to include("is not included in the list")
    end
  end

  context "when living_area field is blank" do
    let(:living_area) { "" }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when participation_process has invalid format" do
    let(:participation_process) { "invalid_format" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when participation_process is blank" do
    let(:participation_process) { "" }

    it "is valid" do
      expect(subject).to be_valid
    end
  end
end
