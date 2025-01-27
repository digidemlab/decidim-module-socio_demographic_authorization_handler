# frozen_string_literal: true

require "spec_helper"

describe "Authorizations", with_authorization_workflows: ["dummy_authorization_handler"] do
  before do
    switch_to_host(organization.host)
  end

  context "when a new user" do
    let(:organization) { create :organization, available_authorizations: authorizations }

    let(:user) { create(:user, :confirmed, organization:) }

    context "when one authorization has been configured" do
      let(:authorizations) { ["dummy_authorization_handler"] }

      before do
        visit decidim.root_path
        find("a", text: "Log in", match: :first).click

        fill_in :session_user_email, with: user.email
        fill_in :session_user_password, with: user.password
        within "form.new_user" do
          find("*[type=submit]").click
        end
        Capybara.current_session.driver.browser.manage.window.resize_to(1024, 2000)
      end

      it "redirects the user to the authorization form after the first sign in" do
        fill_in "Document number", with: "123456789X"
        fill_in :authorization_handler_birthday, with: Time.current.change(day: 12)

        click_on "Send"
        expect(page).to have_content("You have been successfully authorized")
      end

      it "allows the user to skip it" do
        click_on "start exploring"
        expect(page).to have_current_path decidim.account_path
        expect(page).to have_content("Participant settings")
      end
    end

    context "when multiple authorizations have been configured", with_authorization_workflows: %w(dummy_authorization_handler dummy_authorization_workflow) do
      let(:authorizations) { %w(dummy_authorization_handler dummy_authorization_workflow) }

      before do
        visit decidim.root_path
        within "header" do
          click_on "Log in"
        end

        within "form.new_user" do
          fill_in :session_user_email, with: user.email
          fill_in :session_user_password, with: user.password
          find("*[type=submit]").click
        end
      end

      it "allows the user to choose which one to authorize against to" do
        expect(page).to have_css("a.button.button__transparent-secondary", count: 2)
      end
    end
  end

  context "when existing user from her account" do
    let(:organization) { create :organization, available_authorizations: authorizations }
    let(:user) { create(:user, :confirmed, organization:) }

    before do
      login_as user, scope: :user
      visit decidim.root_path
    end

    context "when user has not already been authorized" do
      let(:authorizations) { ["dummy_authorization_handler"] }

      it "allows the user to authorize against available authorizations" do
        visit_authorizations

        click_on "Example authorization"

        fill_in "Document number", with: "123456789X"
        fill_in :authorization_handler_birthday, with: Time.current.change(day: 12)

        click_on "Send"

        expect(page).to have_content("You have been successfully authorized")

        within "#dropdown-menu-profile" do
          click_on "Authorizations"
        end

        within ".authorizations-list" do
          expect(page).to have_content("Example authorization")
          expect(page).to have_no_link("Example authorization")
        end
      end

      it "checks if the given data is invalid" do
        visit_authorizations

        click_on "Example authorization"

        fill_in "Document number", with: "12345678"
        fill_in :authorization_handler_birthday, with: Time.current.change(day: 12)

        click_on "Send"

        expect(page).to have_content("There was a problem creating the authorization.")
      end
    end

    context "when the user has already been authorized" do
      let(:authorizations) { ["dummy_authorization_handler"] }

      let!(:authorization) do
        create(:authorization, name: "dummy_authorization_handler", user:)
      end

      it "shows the authorization at their account" do
        visit_authorizations

        within ".authorizations-list" do
          expect(page).to have_content("Example authorization")
        end
      end

      context "when the authorization has not expired yet" do
        let!(:authorization) do
          create(:authorization, name: "dummy_authorization_handler", user:, granted_at: 2.seconds.ago)
        end

        it "can't be renewed yet" do
          visit_authorizations

          within ".authorizations-list" do
            expect(page).to have_no_link("Example authorization")
            expect(page).to have_content(I18n.l(authorization.granted_at, format: :long_with_particles))
          end
        end
      end

      context "when the authorization has expired" do
        let!(:authorization) do
          create(:authorization, name: "dummy_authorization_handler", user:, granted_at: 2.months.ago)
        end

        it "can be renewed" do
          visit_authorizations

          within ".authorizations-list" do
            expect(page).to have_content("Example authorization")
            find(".verification").click
          end

          click_on "Continue"

          fill_in "Document number", with: "123456789X"
          click_on "Send"

          expect(page).to have_content("You have been successfully authorized")
        end
      end
    end

    context "when no authorizations are configured", with_authorization_handlers: [] do
      let(:authorizations) { [] }

      it "doesn't list authorizations" do
        within_user_menu do
          click_link "My account"
        end

        expect(page).to have_no_content("Authorizations")
      end
    end
  end

  private

  def visit_authorizations
    within_user_menu do
      click_on "My account"
    end

    click_on "Authorizations"
  end
end
