# frozen_string_literal: true

class RegnbagshusetAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :agree_to_be_nice, Boolean
  attribute :agree_no_personal_data, Boolean
  attribute :visited_regnbagshuset, String
  attribute :why_not_visited, String

  VISITED_OPTIONS = %w[yes no want_to].freeze

  validates :agree_to_be_nice, acceptance: { accept: true }
  validates :agree_no_personal_data, acceptance: { accept: true }
  validates :visited_regnbagshuset, inclusion: { in: VISITED_OPTIONS }

  def metadata
    {
      visited_regnbagshuset: visited_regnbagshuset.presence,
      why_not_visited: (why_not_visited.presence if visited_regnbagshuset == "no")
    }.compact
  end
end
