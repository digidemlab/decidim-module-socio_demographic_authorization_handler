# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module SocioDemographicAuthorizationHandler
    module ConfirmationsControllerOverride
      extend ActiveSupport::Concern

      included do
        # Overwrites the default method to handle user groups confirmations.
        def after_confirmation_path_for(resource_name, resource)
          sign_in(resource) unless user_signed_in? # In case you want to sign in the user

          if first_login_and_not_authorized?(resource)
            decidim_verifications.new_authorization_path(action: :new, handler: :socio_demographic_authorization_handler)
          else
            super
          end
        end

        def first_login_and_not_authorized?(user)
          user.is_a?(Decidim::User) && user.sign_in_count == 1 && Decidim::Verifications.find_workflow_manifest(:socio_demographic_authorization_handler) && user.verifiable?
        end
      end
    end
  end
end
