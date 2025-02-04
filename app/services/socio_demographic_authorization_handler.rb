# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class SocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :participatory_space, String
  attribute :gender, String
  attribute :age, String
  attribute :phone_number, String
  attribute :living_area, String

  GENDER_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.genders.map(&:downcase).freeze
  AGE_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.ages.freeze
  LIVING_AREA_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.zones.freeze

  validate :validate_participatory_space
  validates :gender, inclusion: { in: GENDER_OPTIONS }, allow_blank: true
  validates :age, inclusion: { in: AGE_OPTIONS }, allow_blank: true
  validates :phone_number, format: { with: /\A\+?\d{7,20}\z/ }, allow_blank: true
  validates :living_area, inclusion: { in: LIVING_AREA_OPTIONS }, allow_blank: true

  def metadata
    {
      participatory_space: participatory_space.presence,
      gender: gender.presence,
      age: age.presence,
      phone_number: phone_number.presence,
      living_area: living_area.presence
    }.compact
  end

  def validate_participatory_space
    return if participatory_space.blank?

    valid_options = participatory_spaces.map { |space| space.to_global_id.to_s }

    errors.add(:participatory_space, :invalid) unless Array.wrap(participatory_space).all? { |process| valid_options.include?(process) }
  end

  def participatory_spaces
    @participatory_spaces ||= Decidim::ParticipatoryProcess.where(organization: user.organization).published +
                              Decidim::Assemblies::OrganizationPublishedAssemblies.new(user.organization).query
  end
end
