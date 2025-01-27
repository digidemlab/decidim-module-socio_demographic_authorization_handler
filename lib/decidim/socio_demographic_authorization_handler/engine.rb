# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SocioDemographicAuthorizationHandler
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SocioDemographicAuthorizationHandler

      config.to_prepare do
        Decidim::Devise::ConfirmationsController.include(ConfirmationsControllerOverride)
      end
    end
  end
end
