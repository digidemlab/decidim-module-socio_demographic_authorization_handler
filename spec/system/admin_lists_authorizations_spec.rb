# frozen_string_literal: true

require "spec_helper"

describe "Admin lists authorizations" do # rubocop:disable RSpec/DescribeClass
  let!(:organization) do
    create(:organization, available_authorizations: ["socio_demographic_authorization_handler"])
  end

  let(:admin) { create(:admin) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :admin
    visit decidim_system.root_path
    click_on "Organizations"
    click_on translated(organization.name)
  end

  it "allows the system admin to list all available authorization methods" do
    within ".edit_update_organization" do
      expect(page).to have_content("Additional information")
    end
  end
end
