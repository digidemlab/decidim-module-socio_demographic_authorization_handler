# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SocioDemographicAuthorizationHandler
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SocioDemographicAuthorizationHandler

      config.to_prepare do
        ActiveSupport.on_load(:action_view) do
          include Decidim::SocioDemographicAuthorizationHandler::ApplicationHelper
        end

        Decidim::Devise::ConfirmationsController.include(ConfirmationsControllerOverride)
      end
    end
  end
end
