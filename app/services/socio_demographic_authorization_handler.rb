# frozen_string_literal: true

class SocioDemographicAuthorizationHandler < SocioDemographicBaseAuthorizationHandler
  attribute :phone_number, String
  validates :phone_number, format: { with: /\A\+?\d{7,20}\z/ }, presence: true

  def metadata
    {
      participatory_space: participatory_space.presence,
      gender: gender.presence,
      age: age.presence,
      phone_number: phone_number.presence,
      living_area: living_area.presence
    }.compact
  end
end
