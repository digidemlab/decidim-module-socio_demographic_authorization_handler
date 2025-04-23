# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module SocioDemographicAuthorizationHandler
    module ImpersonationsControllerOverride
      extend ActiveSupport::Concern

      included do
        def other_available_authorizations
          return [] if available_authorization_handlers.size == 1

          other_available_authorization_handlers.map do |authorization_handler|
            Decidim::AuthorizationHandler.handler_for(authorization_handler.name, {user:})
          end
        end
      end
    end
  end
end
