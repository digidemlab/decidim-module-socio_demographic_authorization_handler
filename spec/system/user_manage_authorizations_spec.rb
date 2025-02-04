# frozen_string_literal: true

require "spec_helper"

describe "User authorizations" do # rubocop:disable RSpec/DescribeClass
  include Decidim::TranslatableAttributes

  let!(:participatory_spaces) { create_list(:participatory_process, 3, organization:) }
  let(:user) { create(:user, :confirmed, organization:) }
  let!(:organization) do
    create(:organization,
           available_authorizations: ["socio_demographic_authorization_handler"])
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.root_path
    within_user_menu do
      click_on "My account"
    end
    click_on "Authorizations"
  end

  it "displays the authorization item" do
    within ".authorizations-list" do
      expect(page).to have_content("Additional information")
    end
  end

  context "when accessing authorization" do
    before do
      visit "/authorizations"

      click_on "Additional information"
    end

    it "displays authorization form" do
      expect(page).to have_content "Additional information"

      within ".new_authorization_handler" do
        expect(page).to have_content("Living area")
        expect(page).to have_field("Gender")
        expect(page).to have_field("Phone number")
        expect(page).to have_field("Age")
        expect(page).to have_field("Which process will you participate in")
      end
    end

    it "allows user to fill form" do
      select(translated_attribute(participatory_spaces.first.title), from: "Which process will you participate in")
      select("Man", from: "Gender")
      select("16-20", from: "Age")
      fill_in "Phone number", with: "+46701234567"
      select("Bosatt i kranskommun till Göteborg", from: "Living area")
      click_on "Send"

      expect(page).to have_content("You have been successfully authorized")

      authorization = Decidim::Authorization.last

      expect(authorization.user).to eq(user)
      expect(authorization.metadata["gender"]).to eq("man")
      expect(authorization.metadata["age"]).to eq("16-20")
      expect(authorization.metadata["phone_number"]).to eq("+46701234567")
      expect(authorization.metadata["living_area"]).to eq("Bosatt i kranskommun till Göteborg")
      expect(authorization.metadata["participatory_space"]).to eq(participatory_spaces.first.to_global_id.to_s)
    end
  end
end
