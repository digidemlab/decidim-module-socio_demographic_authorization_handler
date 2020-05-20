# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class SocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :gender, String
  attribute :age, String

  GENDER = %w(woman man undefined).freeze
  AGE_SLICE = %w(16-25 26-45 46-65 65+).freeze

  validates :gender,
            inclusion: { in: GENDER, if: proc { |x| x.gender.present? } },
            presence: false

  validates :age,
            inclusion: { in: AGE_SLICE, if: proc { |x| x.age.present? } },
            presence: false

  def metadata
    super.merge(gender: gender, age: age)
  end

  private

  def validate_scope
  end
end
