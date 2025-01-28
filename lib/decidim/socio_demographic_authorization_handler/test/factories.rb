# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :admin, class: "Decidim::System::Admin" do
    sequence(:email) { |n| "admin#{n}@citizen.corp" }
    password { "password12345678" }
    password_confirmation { "password12345678" }
  end
end
