# frozen_string_literal: true

Decidim::Verifications.register_workflow(:socio_demographic_authorization_handler) do |workflow|
  workflow.form = "SocioDemographicAuthorizationHandler"
end

Decidim::Verifications.register_workflow(:socio_demographic_no_phone_authorization_handler) do |workflow|
  workflow.form = "SocioDemographicNoPhoneAuthorizationHandler"
end

Decidim::Verifications.register_workflow(:regnbagshuset_authorization_handler) do |workflow|
  workflow.form = "RegnbagshusetAuthorizationHandler"
end

Decidim::Verifications.register_workflow(:regnbagshuset_ephemeral_authorization_handler) do |workflow|
  workflow.form = "RegnbagshusetEphemeralAuthorizationHandler"
  workflow.ephemeral = true
end
