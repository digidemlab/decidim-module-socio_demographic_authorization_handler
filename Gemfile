# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Inside the development app, the relative require has to be one level up, as
# the Gemfile is copied to the development_app folder (almost) as is.
base_path = ""
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/socio_demographic_authorization_handler/version"

DECIDIM_VERSION = Decidim::SocioDemographicAuthorizationHandler::DECIDIM_VERSION

gem "decidim", DECIDIM_VERSION
gem "decidim-socio_demographic_authorization_handler", path: "."

gem "bootsnap", "~> 1.7"
gem "puma", ">= 6.3.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "brakeman", "~> 5.4"
  gem "decidim-dev", DECIDIM_VERSION

  # Fixes uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger (NameError)
  # Can be removed when upgrading to Decidim 0.29
  gem "concurrent-ruby", "< 1.3.5"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end
