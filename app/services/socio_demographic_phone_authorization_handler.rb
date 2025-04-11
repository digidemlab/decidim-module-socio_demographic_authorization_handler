# frozen_string_literal: true

class SocioDemographicPhoneAuthorizationHandler < SocioDemographicAuthorizationHandler
  validates :phone_number, format: { with: /\A\+?\d{7,20}\z/ }, presence: true

  def to_partial_path
    "socio_demographic_authorization/form"
  end
end
