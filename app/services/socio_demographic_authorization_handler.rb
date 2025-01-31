# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class SocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :participation_process, String
  attribute :gender, String
  attribute :age, String
  attribute :living_area, String

  GENDER_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.genders.map(&:downcase).freeze
  AGE_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.ages.freeze
  LIVING_AREA_OPTIONS = Decidim::SocioDemographicAuthorizationHandler::StaticAuthorizationData.zones.freeze

  validate :validate_participation_process
  validates :gender, inclusion: { in: GENDER_OPTIONS }, allow_blank: true
  validates :age, inclusion: { in: AGE_OPTIONS }, allow_blank: true
  validates :living_area, inclusion: { in: LIVING_AREA_OPTIONS }, allow_blank: true

  def metadata
    {
      participation_process: participation_process.presence,
      gender: gender.presence,
      age: age.presence,
      living_area: living_area.presence
    }.compact
  end

  def validate_participation_process
    return if participation_process.blank?

    valid_options = fetch_participation_options

    errors.add(:participation_process, :invalid) unless Array.wrap(participation_process).all? { |process| valid_options.include?(process) }
  end

  def fetch_participation_options
    participatory_spaces = Decidim::ParticipatoryProcess.where(organization: user.organization).published +
                           Decidim::Assemblies::OrganizationPublishedAssemblies.new(user.organization).query

    participatory_spaces.map { |space| "#{space.manifest.name.to_s.singularize}_id_#{space.id}" }
  end
end
